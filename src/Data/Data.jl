module Data
    using XLSX, DataFrames, Serialization, OrderedCollections, Dates, DelimitedFiles
    using Statistics

    include("DataReader.jl")
    export get_dengue_data, save_data, read_DataFrame
    export df_temp_Ecuador

    include("DataProcessing.jl")
    export normalise_data, get_processed_data, normalise_data_a_b, rescale_data, rescale_data_a_b
end