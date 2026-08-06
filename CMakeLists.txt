cmake_minimum_required(VERSION 3.16)
project(JustBreak VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Qml Quick)

qt_add_executable(JustBreak
    main.cpp
)

# Ship QML and tray icon next to the binary
configure_file(${CMAKE_SOURCE_DIR}/Main.qml ${CMAKE_BINARY_DIR}/Main.qml COPYONLY)
file(COPY ${CMAKE_SOURCE_DIR}/icons DESTINATION ${CMAKE_BINARY_DIR})

target_link_libraries(JustBreak PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
)

install(TARGETS JustBreak RUNTIME DESTINATION bin)
install(FILES Main.qml DESTINATION bin)
install(DIRECTORY icons DESTINATION bin)
