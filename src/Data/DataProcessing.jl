@doc raw"""
    normalise_data(x; dims=ndims(x), a=nothing,b=nothing)

Normalise x to mean zero and standard deviation one.
If a and b are given, x is rescaled in [a,b] instead.
By default it is applied to the last input dimension. 
"""
function normalise_data(x; dims=ndims(x), a=nothing,b=nothing)
    if !isnothing(a) && !isnothing(b)
        return normalise_data_a_b(x, a, b; dims=dims)
    end
    μ = mean(x; dims=dims)
    σ = std(x; dims=dims)
    z = (x .- μ) ./ σ
    return z, μ, σ
end

@doc raw"""
    normalise_data_a_b(x, a, b; dims=ndims(x))

Rescale x in [a,b].
By default it is applied to the last input dimension. 
"""
function normalise_data_a_b(x,a,b; dims=ndims(x))
    z = (b-a) .* (x .- minimum(x,dims=dims)) ./ ( maximum(x,dims=dims) .- minimum(x,dims=dims)) .+ a  
    return z, minimum(x,dims=dims), maximum(x,dims=dims)
end

@doc raw"""
    rescale_data(z, p1, p2;  a=nothing,b=nothing)

Rescale normally distributed z to mean p1 and standard deviation p2
If a and b are given, Rescale z from [a,b] to min p1 and maxi p2.
By default it is applied to the last input dimension. 
"""
function rescale_data(z, p1, p2; a=nothing,b=nothing)
    if !isnothing(a) && !isnothing(b)
        return rescale_data_a_b(x, p1, p2; a=a,b=b)
    end
    x = z .* p2 .+ p1
    return x
end
function rescale_data_a_b(z, minval, maxval; a=0.0, b=1.0)
    x = (z .- a) .* (maxval .- minval) ./ (b -a) .+ minval
    return x
end

@doc raw"""
    get_processed_data(df_dict::Dict, in_date::Date, fin_date::Date; a=nothing, b=nothing)

Given a dictionary of DataFrames df_dict, a starting date in_date and 
a final date fin_date, this function returns an array with normalised data for entry in the dictionary.
It also returns a dictionary containing the normalisation parameters mean and std  to scale back the data.
By default data are normalised with mean zero and standard deviation one.
If a and b are given, data are rescaled in [a,b] and the returned dictionary contains the min and max values to scale back the data. 
"""
function get_processed_data(df_dict::Dict, in_date::Date, fin_date::Date; a=nothing, b=nothing)
    
    tlen = length(in_date:Month(1):fin_date)
    ydata = Array{Float64}(undef, length(df_dict), tlen)
    norm_param = Dict()
    
    for (idx, k) in enumerate(sort(collect(keys(df_dict))))
        filter!(x -> in_date <= x.date <= fin_date, df_dict[k])

        y, p1, p2 = normalise_data(df_dict[k].cases, a=a,b=b)
        norm_param[k] = (p1[1], p2[1])
        ydata[idx,:] = y
    end 
    return  ydata, norm_param
end


