module NeuRG

include("Data/Data.jl")
using .Data
export get_dengue_data, save_data, read_DataFrame, df_temp_Ecuador
export normalise_data, get_processed_data, normalise_data_a_b, rescale_data, rescale_data_a_b


end # module NeuRG
