
# ~/.bashrc for Termux

# Function to display greeting based on time
greet_user() {
    hour=$(date +"%H")
    name=$(whoami)
    current_time=$(date +"%A, %d %B %Y | %I:%M:%S %p")

    if [ "$hour" -lt 12 ]; then
        greeting="Good Morning"
    elif [ "$hour" -lt 17 ]; then
        greeting="Good Afternoon"
    elif [ "$hour" -lt 20 ]; then
        greeting="Good Evening"
    else
        greeting="Good Night"
    fi

    echo -e "\033[1;32m$greeting, $name!\033[0m"
    echo -e "\033[1;34mIt's currently: $current_time\033[0m"
    echo ""
}

# Run the greeting function
greet_user
alias l='ls -lah'                     # List all files in long format with human-readable sizes
alias ll='ls -l'                      # Long listing
alias la='ls -A'                      # List all except . and ..
alias ..='cd ..'                      # Go up one directory
alias ...='cd ../..'                  # Go up two directories
alias c='clear'                       # Clear terminal screen
alias cls='clear'                     # Windows-style clear
alias h='history'                     # Show command history
alias e='exit'                        # Exit terminal
alias ex='git clone git@github.com:BlissNathan1305/Explore.git'
alias ec='cd Explore'
alias ga='git add .'
alias gc='git commit -m 'good''
alias gp='git push'
