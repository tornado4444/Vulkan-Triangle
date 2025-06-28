CXX = g++
CXXFLAGS = -std=c++17 -O2 -Wall -Wextra
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi

SRCDIR = .
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
TARGET = vulkan_app

SHADERS = triangle.vert.spv triangle.frag.spv

.PHONY: all clean debug run

all: $(TARGET)

$(TARGET): $(OBJECTS) $(SHADERS)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.spv: %.vert
	glslangValidator -V $< -o $@

%.spv: %.frag
	glslangValidator -V $< -o $@

debug: CXXFLAGS += -DDEBUG -g
debug: $(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET) $(SHADERS)

run: $(TARGET)
	./$(TARGET)
