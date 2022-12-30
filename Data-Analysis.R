# Load necessary libraries
library(rtweet)
library(tidyverse)
library(randomForest)

# Authenticate with Twitter API
twitter_token <- create_token(
  app = "YOUR_APP_NAME",
  consumer_key = "YOUR_CONSUMER_KEY",
  consumer_secret = "YOUR_CONSUMER_SECRET",
  access_token = "YOUR_ACCESS_TOKEN",
  access_secret = "YOUR_ACCESS_SECRET"
)

# Search Twitter for tweets containing a specific keyword
tweets <- search_tweets("keyword", n = 1000, token = twitter_token)

# Preprocess the data
preprocessed_tweets <- tweets %>%
  select(created_at, screen_name, text, favorite_count, retweet_count) %>%
  mutate(favorite_count = as.numeric(favorite_count),
         retweet_count = as.numeric(retweet_count))

# Split the data into training and test sets
set.seed(123)
split <- sample(2, nrow(preprocessed_tweets), replace = TRUE, prob = c(0.7, 0.3))
train_data <- preprocessed_tweets[split == 1,]
test_data <- preprocessed_tweets[split == 2,]

# Create the machine learning model
model <- randomForest(favorite_count ~ ., data = train_data)

# Make predictions on the test data
predictions <- predict(model, test_data)

# Evaluate the model's performance
accuracy <- mean(predictions == test_data$favorite_count)
print(accuracy)
