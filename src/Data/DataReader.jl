@doc raw"""
    get_dengue_data(path, sheet, ref)
     
    where sheet and ref are the Excel sheet name and the range of cells to read, respectively.
    The function returns a dictionary for each country containing a DataFrame with date and cases.
"""
function get_dengue_data(path::String, sheet::String, ref::String)

    fname = XLSX.readdata(path, sheet, ref)


    df = DataFrame(fname[2:end, :], Symbol.(fname[1,:]))
    filter!(x-> !ismissing(x), df) 

    countries = unique(df.country)
    country_dict = Dict()
    for c in countries
        country_dict[c] = filter(row->row.country == c, df)
        select!(country_dict[c], [:date, :cases])
    end
    return country_dict
end

@doc raw"""
    save_data(dict::Dict; disease="dengue")
    
    Save a dictionary of DataFrame into the database/disease folder. 
    By default disease="dengue".
"""
function save_data(dict::Dict; disease="dengue")

    path = joinpath(join(split(@__DIR__, "/")[1:end-2], "/"), "database")
    if disease ∉ ["dengue"]
        error("No \"$(disease)\" folder found in $(path)")
    end

    for k in collect(keys(dict))
        path_aux = joinpath(path, disease, string(k,".jls"))
        serialize(path_aux, dict[k])
    end
    return nothing
end

@doc raw"""
    read_DataFrame(countries::Vector{String}; disease="dengue")

Given a vector of countries and a disease this function returns a dictionary where each
element is a DataFrame of a country 

read_DataFrame(["Argentina", "Brazil"], disease="dengue)
"""
function read_DataFrame(countries::Vector{String}; disease="dengue")
    sort!(countries)
    path = joinpath(join(split(@__DIR__, "/")[1:end-2], "/"), "database", disease)
    path_countries = filter!(x-> split(basename(x),".")[1] in countries,  readdir(path,join=true))

    res = Dict()
    for (k,c) in enumerate(countries)
        res[c] = deserialize(path_countries[k])
    end
    return res 
end

# data Ecuador average temperature
t_Ecuador_2021 = [77.16 , 79.22 , 79.61 , 80.63 , 80.35 , 80.73 , 77.53 , 76.26 , 75.91 , 76.01 , 77.02 , 77.47] 
t_Ecuador_2022 = [76.28, 78.84 , 80.39 , 80.31 , 78.09 , 75.81 , 75.24 , 76.1 , 75.6 , 75.28 , 75.75 , 79.11]
t_Ecuador_2023 = [81.4 , 80.57 , 80.86 , 80.76 , 82.36 , 81.08 , 80.53 , 79.95 , 80.44 , 80.8 , 79.17 , 81.54]
t_Ecuador_2024 = [81.75 , 82.18 , 83.89 , 83.8 ,82.27 ,80.06, 78.79, 77.6, 78.08, 79.08, 78.53, 81.57]
t_Ecuador = vcat(t_Ecuador_2021, t_Ecuador_2022, t_Ecuador_2023, t_Ecuador_2024)
date_Ecuador = vcat([[Date("$y-$i-01") for i in 1:12] for y in 2021:2024]...)
df_temp_Ecuador = DataFrame(hcat(date_Ecuador, t_Ecuador), [:date, :temp])
