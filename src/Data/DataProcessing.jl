@doc raw"""
    normalise_data(x; dims=ndims(x))

Normalise data to mean zero and standard deviation one.
By default it is applied to the last  input dimension 

"""
function normalise_data(x; dims=ndims(x))
    μ = mean(x; dims=dims)
    σ = std(x; dims=dims)
    z = (x .- μ) ./ σ
    return z, μ, σ
end

@doc raw"""
    normalise_data_a_b(x; dims=ndims(x))

Normalise data to mean zero and standard deviation one.
By default it is applied to the last  input dimension 

"""
function normalise_data_a_b(x; dims=ndims(x), a=0.0,b=1.0)
    z = (b-a) .* (x .- minimum(x,dims=dims)) ./ ( maximum(x,dims=dims) .- minimum(x,dims=dims)) .+ a  
    return z, minimum(x,dims=dims), maximum(x,dims=dims)
end

@doc raw"""
    get_processed_data(df_dict::Dict, in_date::Date, fin_date::Date; a=nothing, b=nothing)

Given a dictionary of DataFrames df_dict, a starting date in_date and 
a final date fin_date, this function returns an array with normalised data for entry in the dictionary.
It also returns a dictionary containing the normalisation parameters (mean and std) necessary to scale back the data.
Currently data are normalised with mean zero and standard deviation one.
TO IMPLEMENT: option of givin a and b to normalise data between a and b extrema.

"""
function get_processed_data(df_dict::Dict, in_date::Date, fin_date::Date; a=nothing, b=nothing)
    
    tlen = length(in_date:Month(1):fin_date)
    ydata = Array{Float64}(undef, length(df_dict), tlen)
    norm_param = Dict()
    
    for (idx, k) in enumerate(keys(df_dict))
        filter!(x -> in_date <= x.date <= fin_date, df_dict[k])
        if isnothing(a) && isnothing(b)
            y, ymean, ystd = normalise_data(df_dict[k].cases)
            norm_param[k] = (ymean[1], ystd[1])
            ydata[idx,:] = y
        else
            y, minval, maxval = normalise_data_a_b(df_dict[k].cases,a=a,b=b)
            norm_param[k] = (minval[1], maxval[1])
            ydata[idx,:] = y
        end
    end 
    return  ydata, norm_param
end

function rescale_data(z, mean_, std_)
    x = z .* std_ .+ mean_
    return x
end

function rescale_data_a_b(z, minval, maxval; a=0.0, b=1.0)
    x = (z .- a) .* (maxval .- minval) ./ (b -a) .+ minval
    return x
end
