cmake_minimum_required(VERSION 3.16)
project(JustBreak VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Qml Quick)

add_executable(JustBreak
    main.cpp
    resources.qrc
)

target_link_libraries(JustBreak PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
)

option(JUSTBREAK_EMBEDDED_RESOURCES "Embed QML and icons in the binary" ON)
if(JUSTBREAK_EMBEDDED_RESOURCES)
    target_compile_definitions(JustBreak PRIVATE JUSTBREAK_EMBEDDED_RESOURCES)
endif()

install(TARGETS JustBreak RUNTIME DESTINATION bin)
