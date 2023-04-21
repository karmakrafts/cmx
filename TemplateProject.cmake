set(CMAKE_C_STANDARD 23)
set(CMAKE_CXX_STANDARD 23)

include(Platform)
include(CommonLibraries)
include(FetchContent)
include(MavenRepository)
include_scripts()

include_fmt()
include_phmap()