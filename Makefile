CXX = g++
CXXFLAGS = -std=c++17 -O2 -Wall -Wextra
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi

SRCDIR = .
SOURCES = $(wildcard $(SRCDIR)/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
TARGET = vulkan_triangle

VERTEX_SHADERS = $(wildcard *.vert)
FRAGMENT_SHADERS = $(wildcard *.frag)
VERTEX_SPV = $(VERTEX_SHADERS:.vert=.vert.spv)
FRAGMENT_SPV = $(FRAGMENT_SHADERS:.frag=.frag.spv) 
SHADERS = $(VERTEX_SPV) $(FRAGMENT_SPV)

.PHONY: all clean debug run shaders

all: $(TARGET)

$(TARGET): $(OBJECTS) $(SHADERS)
	$(CXX) $(OBJECTS) -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.vert.spv: %.vert
	glslangValidator -V $< -o $@

%.frag.spv: %.frag
	glslangValidator -V $< -o $@

debug: CXXFLAGS += -DDEBUG -g
debug: $(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET) $(SHADERS)

run: $(TARGET)
	./$(TARGET)
