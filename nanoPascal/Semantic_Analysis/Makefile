# Makefile for compiling a C++ program on Windows using g++

# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -Wall -Wextra

# Source files
SRCS = NegashA_Zeray.cxx

# Object files
OBJS = $(SRCS:.cxx=.o)

# Executable name
EXEC = program.exe

# Default target
all: $(EXEC)

# Rule for compiling object files
%.o: %.cxx
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Rule for linking object files into executable
$(EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@

# Clean target
clean:
	del $(OBJS) $(EXEC)
