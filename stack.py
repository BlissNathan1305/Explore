class Stack:
    def __init__(self):
        self.stack = []

    def push(self, value):
        """Add an element to the top of the stack"""
        self.stack.append(value)
        print(f"Pushed {value} onto the stack")

    def pop(self):
        """Remove an element from the top of the stack"""
        if self.is_empty():
            print("Stack is empty")
            return None
        value = self.stack.pop()
        print(f"Popped {value} from the stack")
        return value

    def peek(self):
        """Return the top element of the stack without removing it"""
        if self.is_empty():
            print("Stack is empty")
            return None
        return self.stack[-1]

    def is_empty(self):
        """Check if the stack is empty"""
        return len(self.stack) == 0

    def size(self):
        """Return the number of elements in the stack"""
        return len(self.stack)

    def display(self):
        """Print the elements of the stack"""
        print("Stack:", self.stack)

# Create a new stack
stack = Stack()

# Push elements onto the stack
stack.push(1)
stack.push(2)
stack.push(3)
stack.display()  # Output: Stack: [1, 2, 3]

# Peek at the top element
print("Top element:", stack.peek())  # Output: Top element: 3

# Pop elements from the stack
stack.pop()
stack.display()  # Output: Stack: [1, 2]

# Check if the stack is empty
print("Is stack empty?", stack.is_empty())  # Output: Is stack empty? False

# Get the size of the stack
print("Stack size:", stack.size())  # Output: Stack size: 2

# Pop all elements from the stack
stack.pop()
stack.pop()
stack.display()  # Output: Stack: []

# Check if the stack is empty
print("Is stack empty?", stack.is_empty())  # Output: Is stack empty? True
