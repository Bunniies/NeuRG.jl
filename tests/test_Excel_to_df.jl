# using Revise
using NeuRG
using Serialization

path_excel = "/Users/alessandroconigli/MyDrive/postdoc-mainz/projects/neoRG/test_dengue/data/dengue-global-data-2025-01-27.xlsx"
sheet = "data"
ref = "A1:G8391"

# read all data from excel file 
country_dict  = get_dengue_data(path_excel, sheet, ref)

# save data in database/
save_data(country_dict; disease="dengue")

# read data in internal database
path_read = "/Users/alessandroconigli/.julia/dev/NeuRG/database/dengue/Ecuador.jls"
df_Ecudaor_cases = deserialize(path_read)

# DataFrame with Ecuador temperature is hardcoded in Data/DataReader.jl atm, available only from 01/2021 to 12/2024
df_temp_Ecuador