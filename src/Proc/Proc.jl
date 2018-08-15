module Proc
export cubeAnomalies, removeMSC, gapFillMSC, normalizeTS, simpleAnomalies,
  sampleLandPoints, getMSC, filterTSFFT, getNpY, getMedSC, DATfitOnline,
  spatialinterp, extractLonLats, cubePCA, rotation_matrix, transformPCA, explained_variance,exportcube
importall ..DAT, ..CubeAPI, ..Cubes
macro no_ocean(maskin,maskout)
    esc(quote
        if ($(maskin)[1] & OCEAN) == OCEAN
            $maskout[:]=OCEAN
            return nothing
        end
    end)
end

import Base.Dates.year
function getNpY(cube::AbstractCubeData)
    axlist=axes(cube)
    isTime=[isa(a,TimeAxis) for a in axlist]
    timax = axlist[isTime][1]
    years = year.(timax.values)
    years[end]>years[1]+1 || error("Must have at least 3 years to calculate MSC")
    return count(i->i==years[1]+1,years)
end
getNpY(cube::InputCube)=getNpY(cube.cube)

include("Online/OnlineStats.jl")
include("MSC.jl")
include("Outlier.jl")
include("Stats.jl")
include("CubeIO.jl")
include("TSDecomposition.jl")
include("remap.jl")
importall .ReSample, .MSC, .Outlier, .Stats, .CubeIO,
  .TSDecomposition, .DATOnlineStats



end
