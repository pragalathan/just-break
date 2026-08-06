CXX ?= g++
CXXFLAGS ?= -std=c++17 -fPIC -Wall

QT_INCLUDE ?= /usr/include/x86_64-linux-gnu/qt6
LOCAL_DEPS := $(CURDIR)/.deps/usr/include/x86_64-linux-gnu/qt6
LOCAL_LIB  := $(CURDIR)/.deps/usr/lib/x86_64-linux-gnu

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

.PHONY: all clean run

all: $(BINDIR)/JustBreak $(BINDIR)/Main.qml \
	$(BINDIR)/icons/tux_sleep.png $(BINDIR)/icons/tux_sleep_paused.png

$(BINDIR):
	mkdir -p $(BINDIR)

$(BINDIR)/icons:
	mkdir -p $(BINDIR)/icons

$(BINDIR)/JustBreak: main.cpp | $(BINDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $< -o $@ $(LIBS)

$(BINDIR)/Main.qml: Main.qml | $(BINDIR)
	cp $< $@

$(BINDIR)/icons/tux_sleep.png: icons/tux_sleep.png | $(BINDIR)/icons
	cp $< $@

$(BINDIR)/icons/tux_sleep_paused.png: icons/tux_sleep_paused.png | $(BINDIR)/icons
	cp $< $@

run: all
	./$(BINDIR)/JustBreak

clean:
	rm -rf $(BINDIR)/JustBreak $(BINDIR)/Main.qml $(BINDIR)/icons
