use godot::prelude::*;
use rayon::prelude::*;

const PRICE_TOLERANCE: f64 = 0.2;
const SEARCH_TOLERANCE: f64 = 0.01;
type VariantDictionary = Dictionary<Variant, Variant>;
type VariantArray = Array<Variant>;

#[derive(GodotClass)]
#[class(base=RefCounted)]
struct EconomicRust {
    _base: Base<RefCounted>,
}

#[godot_api]
impl IRefCounted for EconomicRust {
    fn init(base: Base<RefCounted>) -> Self {
        Self { _base: base }
    }
}

#[derive(Clone)]
struct RegionState {
    region_id: String,
    prices: Vec<f64>,
    equilibrium_prices: Vec<f64>,
    offered_supply: Vec<f64>,
    latent_demand: Vec<f64>,
    sold_supply: Vec<f64>,
    supplied_demand: Vec<f64>,
    export_amounts: Vec<f64>,
    import_amounts: Vec<f64>,
    offer_price_volumes: Vec<f64>,
}

#[derive(Clone)]
struct TradeRecord {
    source_index: usize,
    target_index: usize,
    good_index: usize,
    amount: f64,
    transport: f64,
}

#[derive(Clone)]
struct GoodRegionState {
    price: f64,
    equilibrium_price: f64,
    offered_supply: f64,
    latent_demand: f64,
    sold_supply: f64,
    supplied_demand: f64,
    export_amount: f64,
    import_amount: f64,
    offer_price_volume: f64,
}

struct GoodSimulationResult {
    good_index: usize,
    regions: Vec<GoodRegionState>,
    trades: Vec<TradeRecord>,
}

#[godot_api]
impl EconomicRust {
    #[func]
    fn simulate_market_cycle(
        &self,
        region_inputs: VariantArray,
        region_ids: PackedStringArray,
        good_names: PackedStringArray,
        good_weights: PackedFloat64Array,
        distance_matrix: VariantArray,
        min_trade: f64,
        max_trades_per_good: i32,
    ) -> VariantDictionary {
        let mut regions = parse_regions(region_inputs);
        let distances = parse_distance_matrix(distance_matrix);
        let good_weights = good_weights.as_slice().to_vec();
        let good_count = good_names.len() as usize;
        let region_count = regions.len();

        let mut good_results: Vec<GoodSimulationResult> = (0..good_count)
            .into_par_iter()
            .map(|good_index| {
                let good_regions = regions
                    .iter()
                    .map(|region| GoodRegionState {
                        price: region.prices[good_index],
                        equilibrium_price: region.equilibrium_prices[good_index],
                        offered_supply: region.offered_supply[good_index],
                        latent_demand: region.latent_demand[good_index],
                        sold_supply: region.sold_supply[good_index],
                        supplied_demand: region.supplied_demand[good_index],
                        export_amount: region.export_amounts[good_index],
                        import_amount: region.import_amounts[good_index],
                        offer_price_volume: region.offer_price_volumes[good_index],
                    })
                    .collect();

                simulate_good(
                    good_regions,
                    &distances,
                    good_weights.get(good_index).copied().unwrap_or(0.0),
                    good_index,
                    min_trade,
                    max_trades_per_good,
                )
            })
            .collect();
        good_results.sort_by_key(|result| result.good_index);

        let mut trades: Vec<TradeRecord> = Vec::new();
        for result in good_results {
            for (region_index, good_region) in result.regions.into_iter().enumerate() {
                regions[region_index].sold_supply[result.good_index] = good_region.sold_supply;
                regions[region_index].supplied_demand[result.good_index] =
                    good_region.supplied_demand;
                regions[region_index].export_amounts[result.good_index] =
                    good_region.export_amount;
                regions[region_index].import_amounts[result.good_index] =
                    good_region.import_amount;
                regions[region_index].offer_price_volumes[result.good_index] =
                    good_region.offer_price_volume;
            }
            trades.extend(result.trades);
        }

        let mut result = VariantDictionary::new();
        let mut region_results = VariantArray::new();
        for region in &regions {
            let mut region_result = VariantDictionary::new();
            region_result.set("region_id", region.region_id.as_str());
            let sold_supply = array_from_f64(&region.sold_supply).to_variant();
            let supplied_demand = array_from_f64(&region.supplied_demand).to_variant();
            let export_amounts = array_from_f64(&region.export_amounts).to_variant();
            let import_amounts = array_from_f64(&region.import_amounts).to_variant();
            let offer_price_volumes = array_from_f64(&region.offer_price_volumes).to_variant();
            region_result.set("sold_supply", &sold_supply);
            region_result.set("supplied_demand", &supplied_demand);
            region_result.set("export_amounts", &export_amounts);
            region_result.set("import_amounts", &import_amounts);
            region_result.set("offer_price_volumes", &offer_price_volumes);
            region_results.push(&region_result.to_variant());
        }

        let mut trade_results = VariantArray::new();
        for trade in trades {
            let mut trade_result = VariantDictionary::new();
            let source_region_id = region_ids.get(trade.source_index).unwrap_or_default();
            let target_region_id = region_ids.get(trade.target_index).unwrap_or_default();
            let good_name = good_names.get(trade.good_index).unwrap_or_default();
            trade_result.set("source_region_id", &source_region_id);
            trade_result.set("target_region_id", &target_region_id);
            trade_result.set("good", &good_name);
            trade_result.set("amount", trade.amount);
            trade_result.set("transport", trade.transport);
            trade_results.push(&trade_result.to_variant());
        }

        let region_results_variant = region_results.to_variant();
        let trade_results_variant = trade_results.to_variant();
        result.set("regions", &region_results_variant);
        result.set("trades", &trade_results_variant);
        debug_assert_eq!(region_results.len() as usize, region_count);
        result
    }
}

fn simulate_good(
    mut regions: Vec<GoodRegionState>,
    distances: &[Vec<f64>],
    good_weight: f64,
    good_index: usize,
    min_trade: f64,
    max_trades_per_good: i32,
) -> GoodSimulationResult {
    let mut trades = Vec::new();
    let mut request_indices: Vec<usize> = (0..regions.len())
        .filter(|&index| regions[index].latent_demand > 0.0)
        .collect();
    request_indices.sort_unstable();

    for region_index in request_indices.iter().copied() {
        let local_amount = regions[region_index]
            .latent_demand
            .min(regions[region_index].offered_supply);
        if local_amount <= 0.0 {
            continue;
        }

        regions[region_index].latent_demand -= local_amount;
        regions[region_index].offered_supply -= local_amount;
        regions[region_index].sold_supply += local_amount;
        regions[region_index].supplied_demand += local_amount;
    }

    let mut offer_indices: Vec<usize> = (0..regions.len())
        .filter(|&index| regions[index].offered_supply > 0.0)
        .collect();
    offer_indices.sort_unstable();

    for target_index in request_indices {
        let mut desired_amount = regions[target_index].latent_demand;
        if desired_amount <= 0.0 {
            continue;
        }

        let mut trade_count = 0;
        loop {
            if desired_amount <= 0.0 || trade_count >= max_trades_per_good {
                break;
            }

            let mut best_source: Option<usize> = None;
            let mut best_transport = 0.0;
            let mut best_trade_amount = 0.0;

            for source_index in offer_indices.iter().copied() {
                if regions[source_index].offered_supply <= 0.0 {
                    continue;
                }
                if regions[source_index].price >= regions[target_index].price {
                    continue;
                }

                let transport = 0.5 * distances[source_index][target_index] * good_weight;
                let trade_amount = get_arbitrage_amount(
                    &regions[source_index],
                    desired_amount,
                    &regions[target_index],
                    regions[source_index].offered_supply,
                    transport,
                );

                if trade_amount > min_trade && trade_amount > best_trade_amount {
                    best_source = Some(source_index);
                    best_transport = transport;
                    best_trade_amount = snapped(trade_amount);
                }
            }

            let Some(source_index) = best_source else {
                break;
            };

            desired_amount -= best_trade_amount;
            trade_count += 1;

            let source_equilibrium_price = regions[source_index].equilibrium_price;
            regions[source_index].offered_supply -= best_trade_amount;
            regions[source_index].sold_supply += best_trade_amount;
            regions[source_index].export_amount += best_trade_amount;

            regions[target_index].import_amount += best_trade_amount;
            regions[target_index].supplied_demand += best_trade_amount;
            regions[target_index].offer_price_volume +=
                best_trade_amount * (source_equilibrium_price + best_transport);
            regions[target_index].latent_demand = desired_amount;

            trades.push(TradeRecord {
                source_index,
                target_index,
                good_index,
                amount: best_trade_amount,
                transport: best_transport,
            });
        }
    }

    GoodSimulationResult {
        good_index,
        regions,
        trades,
    }
}

fn get_arbitrage_amount(
    source: &GoodRegionState,
    desired: f64,
    target: &GoodRegionState,
    available: f64,
    transport: f64,
) -> f64 {
    let mut q_low = 0.0;
    let mut q_high = desired.min(available);
    let mut best_q = 0.0;

    let source_price_base = source.equilibrium_price;
    let source_supply = source.offered_supply;
    let source_demand = source.latent_demand + source.export_amount;

    let target_supply = target.offered_supply;
    let target_demand = target.latent_demand;
    let target_import = target.import_amount;
    let target_offer_price_volume = target.offer_price_volume;

    while q_high - q_low > SEARCH_TOLERANCE {
        let q_mid = (q_low + q_high) / 2.0;
        let price_source_after = compute_price(source_price_base, source_supply, source_demand + q_mid);

        let target_price_volume_after_trade = target_offer_price_volume + source_price_base * q_mid;
        let target_amount_of_offers = target_supply + target_import + q_mid;
        let target_base_price = target_price_volume_after_trade / target_amount_of_offers;
        let price_target_after = compute_price(
            target_base_price,
            target_supply + q_mid + target_import,
            target_demand,
        );

        if price_source_after + transport + PRICE_TOLERANCE < price_target_after {
            best_q = q_mid;
            q_low = q_mid;
        } else {
            q_high = q_mid;
        }
    }

    best_q
}

fn compute_price(baseprice: f64, supply: f64, demand: f64) -> f64 {
    let pricefactor = (1.0 + (demand - supply) / (supply + 1.0)).clamp(0.25, 1.75);
    snapped(baseprice * pricefactor)
}

fn parse_regions(region_inputs: VariantArray) -> Vec<RegionState> {
    let mut regions = Vec::new();
    for region_variant in region_inputs.iter_shared() {
        let Ok(region_dict) = region_variant.try_to::<VariantDictionary>() else {
            continue;
        };
        regions.push(RegionState {
            region_id: read_string(&region_dict, "region_id"),
            prices: read_f64_array(&region_dict, "prices"),
            equilibrium_prices: read_f64_array(&region_dict, "equilibrium_prices"),
            offered_supply: read_f64_array(&region_dict, "offered_supply"),
            latent_demand: read_f64_array(&region_dict, "latent_demand"),
            sold_supply: read_f64_array(&region_dict, "sold_supply"),
            supplied_demand: read_f64_array(&region_dict, "supplied_demand"),
            export_amounts: read_f64_array(&region_dict, "export_amounts"),
            import_amounts: read_f64_array(&region_dict, "import_amounts"),
            offer_price_volumes: read_f64_array(&region_dict, "offer_price_volumes"),
        });
    }
    regions
}

fn parse_distance_matrix(distance_matrix: VariantArray) -> Vec<Vec<f64>> {
    let mut matrix = Vec::new();
    for row_variant in distance_matrix.iter_shared() {
        let Ok(row) = row_variant.try_to::<PackedFloat64Array>() else {
            matrix.push(Vec::new());
            continue;
        };
        matrix.push(row.as_slice().to_vec());
    }
    matrix
}

fn array_from_f64(values: &[f64]) -> PackedFloat64Array {
    let mut array = PackedFloat64Array::new();
    for value in values {
        array.push(*value);
    }
    array
}

fn read_string(dict: &VariantDictionary, key: &str) -> String {
    dict.get(key)
        .map(|variant| variant.to::<GString>().to_string())
        .unwrap_or_default()
}

fn read_f64_array(dict: &VariantDictionary, key: &str) -> Vec<f64> {
    let Some(variant) = dict.get(key) else {
        return Vec::new();
    };
    let Ok(array) = variant.try_to::<PackedFloat64Array>() else {
        return Vec::new();
    };
    array.as_slice().to_vec()
}

fn snapped(value: f64) -> f64 {
    (value * 100.0).round() / 100.0
}

struct StrategyEconomyExtension;

#[gdextension]
unsafe impl ExtensionLibrary for StrategyEconomyExtension {}
