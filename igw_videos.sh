julia --project="env" -t 1 -- src/igw.jl video/quadratic-0.mp4 2 0.000 40 2000 &
julia --project="env" -t 1 -- src/igw.jl video/quadratic-1.mp4 2 0.785 40 2000 & 
julia --project="env" -t 1 -- src/igw.jl video/quadratic-2.mp4 2 1.571 40 2000 &
julia --project="env" -t 1 -- src/igw.jl video/quadratic-3.mp4 2 2.356 40 2000 & wait
julia --project="env" -t 1 -- src/igw.jl video/quadratic-4.mp4 2 3.142 40 2000 &
julia --project="env" -t 1 -- src/igw.jl video/quadratic-5.mp4 2 3.927 40 2000 &
julia --project="env" -t 1 -- src/igw.jl video/quadratic-6.mp4 2 4.712 40 2000 &
julia --project="env" -t 1 -- src/igw.jl video/quadratic-7.mp4 2 5.498 40 2000 & wait
