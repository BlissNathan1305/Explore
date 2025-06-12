import requests
import pandas as pd

# Define API endpoint and API key
api_endpoint = "https://finnhub.io/api/v1/quote"
api_key = "YOUR_FINNHUB_API_KEY"  # replace with your API key

# Define NASDAQ stock symbols
stock_symbols = ["QQQ", "NDAQ", "JEPQ", "MSFT", "AAPL", "NVDA", "AMZN"]

# Function to get stock data
def get_stock_data(symbol):
    params = {
        "symbol": symbol,
        "token": api_key
    }
    response = requests.get(api_endpoint, params=params)
    return response.json()

# Function to calculate performance
def calculate_performance(stock_data):
    return stock_data["dp"]  # dp is the percentage change

# Get stock data and calculate performance
stock_performance = []
for symbol in stock_symbols:
    stock_data = get_stock_data(symbol)
    performance = calculate_performance(stock_data)
    stock_performance.append({
        "Symbol": symbol,
        "Performance": performance
    })

# Convert to DataFrame and sort by performance
df = pd.DataFrame(stock_performance)
df = df.sort_values(by="Performance", ascending=False)

# Print the best-performing stocks
print(df)
