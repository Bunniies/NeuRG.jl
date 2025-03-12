module Data
    using XLSX, DataFrames, Serialization, OrderedCollections, Dates, DelimitedFiles

    include("DataReader.jl")
    export get_dengue_data, save_data, read_DataFrame
    export df_temp_Ecuador

end