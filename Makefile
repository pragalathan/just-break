CXX ?= g++
CXXFLAGS ?= -std=c++17 -fPIC -Wall
CXXFLAGS_RELEASE ?= -std=c++17 -fPIC -Wall -O3 -DNDEBUG
QT6_QML_CONFIG ?= /usr/lib/x86_64-linux-gnu/cmake/Qt6Qml/Qt6QmlConfig.cmake

QT_INCLUDE ?= /usr/include/x86_64-linux-gnu/qt6
LOCAL_DEPS := $(CURDIR)/.deps/usr/include/x86_64-linux-gnu/qt6
LOCAL_LIB  := $(CURDIR)/.deps/usr/lib/x86_64-linux-gnu
RCC ?= /usr/lib/qt6/libexec/rcc
QRC_CPP = qrc_resources.cpp

# Prefer system QML headers; fall back to extracted .deps if present
ifeq ($(wildcard $(QT_INCLUDE)/QtQml/QtQml),)
  ifneq ($(wildcard $(LOCAL_DEPS)/QtQml/QtQml),)
    EXTRA_INCLUDE += -I$(LOCAL_DEPS) \
	-I$(LOCAL_DEPS)/QtQml \
	-I$(LOCAL_DEPS)/QtQuick
    EXTRA_LDFLAGS += -L$(LOCAL_LIB)
  endif
endif

INCLUDES = \
	-I$(QT_INCLUDE) \
	-I$(QT_INCLUDE)/QtCore \
	-I$(QT_INCLUDE)/QtGui \
	-I$(QT_INCLUDE)/QtWidgets \
	-I$(QT_INCLUDE)/QtQml \
	-I$(QT_INCLUDE)/QtQuick \
	-I$(QT_INCLUDE)/QtNetwork \
	$(EXTRA_INCLUDE)

LIBS = $(EXTRA_LDFLAGS) -lQt6Widgets -lQt6Quick -lQt6Qml -lQt6Gui -lQt6Core

BINDIR = bin
RELEASE_DIR = build-release

.PHONY: all clean run release release-local install

all: $(BINDIR)/JustBreak $(BINDIR)/Main.qml \
	$(BINDIR)/icons/tux_sleep.png $(BINDIR)/icons/tux_sleep_paused.png \
	$(BINDIR)/fonts/SmoochSans-Bold.ttf \
	$(BINDIR)/fonts/SmoochSans-SemiBold.ttf \
	$(BINDIR)/fonts/Abel-Regular.ttf

$(BINDIR):
	mkdir -p $(BINDIR)

$(BINDIR)/icons:
	mkdir -p $(BINDIR)/icons

$(BINDIR)/fonts:
	mkdir -p $(BINDIR)/fonts

$(BINDIR)/JustBreak: main.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $< -o $@ $(LIBS)

$(BINDIR)/Main.qml: Main.qml | $(BINDIR)
	cp $< $@

$(BINDIR)/icons/tux_sleep.png: icons/tux_sleep.png | $(BINDIR)/icons
	cp $< $@

$(BINDIR)/icons/tux_sleep_paused.png: icons/tux_sleep_paused.png | $(BINDIR)/icons
	cp $< $@

$(BINDIR)/fonts/SmoochSans-Bold.ttf: fonts/SmoochSans-Bold.ttf | $(BINDIR)/fonts
	cp $< $@

$(BINDIR)/fonts/SmoochSans-SemiBold.ttf: fonts/SmoochSans-SemiBold.ttf | $(BINDIR)/fonts
	cp $< $@

$(BINDIR)/fonts/Abel-Regular.ttf: fonts/Abel-Regular.ttf | $(BINDIR)/fonts
	cp $< $@

run: all
	./$(BINDIR)/JustBreak

# Production build: embeds Main.qml and icons into the binary (no sidecar files).
# Uses CMake when Qt6 Qml CMake configs are present (qt6-declarative-dev);
# otherwise falls back to rcc + g++ so `make release` still works.
release:
	@if [ -f "$(QT6_QML_CONFIG)" ]; then \
		cmake -S . -B $(RELEASE_DIR) -DCMAKE_BUILD_TYPE=Release \
			-DJUSTBREAK_EMBEDDED_RESOURCES=ON && \
		cmake --build $(RELEASE_DIR) -j$$(nproc); \
	else \
		echo "Qt6 Qml CMake config not found ($(QT6_QML_CONFIG))."; \
		echo "Building with rcc instead (install qt6-declarative-dev to use CMake)."; \
		$(MAKE) release-local; \
	fi

# Makefile-only production build (no qt6-declarative-dev cmake modules required)
release-local: $(RELEASE_DIR)/JustBreak

$(QRC_CPP): resources.qrc Main.qml icons/tux_sleep.png icons/tux_sleep_paused.png fonts/SmoochSans-Bold.ttf fonts/SmoochSans-SemiBold.ttf fonts/Abel-Regular.ttf
	$(RCC) -o $@ resources.qrc

$(RELEASE_DIR):
	mkdir -p $(RELEASE_DIR)

$(RELEASE_DIR)/JustBreak: main.cpp $(QRC_CPP) | $(RELEASE_DIR)
	$(CXX) $(CXXFLAGS_RELEASE) -DJUSTBREAK_EMBEDDED_RESOURCES $(INCLUDES) main.cpp $(QRC_CPP) -o $@ $(LIBS)

install: release
	@if [ -f "$(RELEASE_DIR)/cmake_install.cmake" ]; then \
		cmake --install $(RELEASE_DIR) --prefix dist; \
	else \
		mkdir -p dist/bin && cp $(RELEASE_DIR)/JustBreak dist/bin/; \
	fi

clean:
	rm -rf $(BINDIR)/JustBreak $(BINDIR)/Main.qml $(BINDIR)/icons $(BINDIR)/fonts $(RELEASE_DIR) dist $(QRC_CPP)
