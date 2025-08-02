# ---------------------------
# Importing Libraries required
# ---------------------------

library(GGally)
library(VIM)
library(ggplot2)
library(caret)
library(dplyr)
library(pROC)
library(scales)

# ---------------------------
# Loading and Preparing Data
# ---------------------------

###Loading dataset
heart_data <- read.csv("C:\\Users\\HP\\OneDrive\\Documents\\heart.csv")

###Basic checks
head(heart_data)
colnames(heart_data)
dim(heart_data)

# ---------------------------
# Correlation Analysis
# ---------------------------

###Selecting numeric variables
num_vars <- heart_data[sapply(heart_data, is.numeric)]

###Plotting correlation matrix
ggcorr(num_vars, 
       label = TRUE, 
       label_round = 2, 
       label_size = 3, 
       low = "blue", mid = "white", high = "red", 
       name = "Correlation")

# ---------------------------
# Exploratory Data Analysis
# ---------------------------

###Distribution plot of numeric variables

par(mfrow=c(2,2))
hist(heart_clean$Age,main = "Distribution of Age",xlab = "Age", col = "skyblue", prob = TRUE); lines(density(heart_clean$Age))
hist(heart_clean$RestingBP,main = "Distribution of Resting BP",xlab = "Resting BP", col = "pink", prob = TRUE); lines(density(heart_clean$RestingBP))
hist(heart_clean$Cholesterol, main = "Distribution of Cholesterol",xlab = "Cholesterol", col = "lightgreen", prob = TRUE); lines(density(heart_clean$Cholesterol))
hist(heart_clean$MaxHR, col = "salmon",xlab = "Max Heart Rate",main = "Distribution of Max Heart Rate", prob = TRUE); lines(density(heart_clean$MaxHR))
par(mfrow=c(1,1))

###Boxplot of Age,RestingBP,Cholesterol and MaxHR
par(mfrow=c(2,2))
boxplot(Age ~ HeartDisease, data = heart_data, main = "Age vs. Heart Disease",
        xlab = "Heart Disease (0 = No, 1 = Yes)", ylab = "Age", col = c("lightblue", "salmon"))
boxplot(RestingBP ~ HeartDisease, data = heart_data, main = "Resting BP vs. Heart Disease",
        xlab = "Heart Disease (0 = No, 1 = Yes)", ylab = "Resting BP", col = c("lightblue", "salmon"))
boxplot(Cholesterol ~ HeartDisease, data = heart_data, main = "Cholesterol vs. Heart Disease",
        xlab = "Heart Disease (0 = No, 1 = Yes)", ylab = "Cholesterol", col = c("lightblue", "salmon"))
boxplot(MaxHR ~ HeartDisease, data = heart_data, main = "Max Heart Rate vs. Heart Disease",
        xlab = "Heart Disease (0 = No, 1 = Yes)", ylab = "Max Heart Rate", col = c("lightblue", "salmon"))

###Hence we can clearly see the missing values of RestingBP and Cholesterol is in the form of numeric value 0
###So we have to impute those as removing those values may delete important information

# ---------------------------
# Handling Missing Values
# ---------------------------

colSums(is.na(heart_data))

###Replace 0s with NA
heart_data$RestingBP[heart_data$RestingBP == 0] <- NA
heart_data$Cholesterol[heart_data$Cholesterol == 0] <- NA

colSums(is.na(heart_data))

###Imputing missing values using KNN

heart_knn <- kNN(heart_data, variable = c("Cholesterol", "RestingBP"), k = 5)
head(heart_knn)
heart_clean <- subset(heart_knn, select = -c(Cholesterol_imp, RestingBP_imp))
head(heart_clean)

###Saving the cleaned data set

write.csv(heart_clean,"C:\\Users\\HP\\OneDrive\\Documents\\heart_clean.csv", row.names = FALSE)

###Now checking the columns of Cholesterol and RestingBP by plotting it again

par(mfrow=c(1,2))
hist(heart_clean$Cholesterol,breaks=30, main = "Distribution of Cholesterol",ylab="Count", xlab = "Cholesterol", col = "skyblue", prob=TRUE)
lines(density(heart_clean$Cholesterol))
grid(col = rgb(0.5, 0.5, 0.5, alpha = 0.3), lty = "dotted")
hist(heart_clean$RestingBP,breaks=30, main = "Distribution of Resting BP",ylab="Count", xlab = "Resting BP", col = "skyblue", prob=TRUE)
lines(density(heart_clean$RestingBP))
grid(col = rgb(0.5, 0.5, 0.5, alpha = 0.3), lty = "dotted")
par(mfrow=c(1,1))

# ---------------------------
# Visualizing the Target variable distribution
# ---------------------------

barplot(table(heart_clean$HeartDisease),main = "Distribution of Heart Disease",xlab = "Heart Disease",ylab = "Count",col = c("lightblue", "tomato"), names.arg = c("No", "Yes"))
prop.table(table(heart_clean$HeartDisease))

### 44.6% Normal(=0) and 55.3% having Heart disease(=1)

###Hence we can see that the target variable is balanced

# ---------------------------
# Data Encoding
# ---------------------------

###Let us now see how the other variable is affecting the chance of having heart disease by using ggplot
###To use ggplot we need to first transform the variable to factor

heart_clean$ST_Slope <- as.factor(heart_clean$ST_Slope)
heart_clean$Sex <- as.factor(heart_clean$Sex)
heart_clean$ChestPainType <- as.factor(heart_clean$ChestPainType)
heart_clean$RestingECG <- as.factor(heart_clean$RestingECG)
heart_clean$ExerciseAngina <- as.factor(heart_clean$ExerciseAngina)
heart_clean$HeartDisease <- as.factor(heart_clean$HeartDisease)
heart_clean$FastingBS <- as.factor(heart_clean$FastingBS)

# ---------------------------
# Visualizations (Categorical variables vs Heart Disease)
# ---------------------------

ggplot(heart_clean,aes(x=Sex,fill=HeartDisease))+geom_bar(position="dodge")+xlab("Gender")+ylab("count")+ggtitle("Heart Disease by Gender")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$Sex))
ggplot(heart_clean,aes(x=ChestPainType,fill=HeartDisease))+geom_bar(position="dodge")+xlab("Chest pain")+ylab("count")+ggtitle("Heart Disease by Chest Pain type")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$ChestPainType))
ggplot(heart_clean,aes(x=ExerciseAngina,fill=HeartDisease))+geom_bar(position="dodge")+xlab("Exercise induced Angina")+ylab("count")+ggtitle("Heart Disease by Exercise induced Angina")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$ExerciseAngina))
ggplot(heart_clean,aes(x=ST_Slope,fill=HeartDisease))+geom_bar(position="dodge")+xlab("ST slope")+ylab("count")+ggtitle("Heart Disease by ST slope")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$ST_Slope))
ggplot(heart_clean,aes(x=FastingBS,fill=HeartDisease))+geom_bar(position="dodge")+xlab("Fasting Blood Sugar")+ylab("count")+ggtitle("Heart Disease by Fasting Blood Sugar")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$FastingBS))
ggplot(heart_clean,aes(x=RestingECG,fill=HeartDisease))+geom_bar(position="dodge")+xlab("Resting ECG")+ylab("count")+ggtitle("Heart Disease by Resting ECG")+scale_fill_discrete(name='Heart Disease');prop.table(table(heart_clean$RestingECG))

# ---------------------------
# Logistic Regression Model
# ---------------------------

set.seed(123)

###Creating Training and Test data
trainIndex <- createDataPartition(heart_clean$HeartDisease, p = 0.7, list = FALSE)
train_data <- heart_clean[trainIndex, ]
test_data <- heart_clean[-trainIndex, ]

###Standardizing the numeric variables

standard_params<-preProcess(train_data[,-c(3,6,7,9,11,12)],method=c("center","scale"))
train_data_scaled <- predict(standard_params,train_data)
test_data_scaled <- predict(standard_params,test_data)
head(train_data_scaled)
head(test_data_scaled)

###Fitting the model

logit_model <- glm(HeartDisease ~ ., data = train_data_scaled, family = binomial)
summary(logit_model)

# ---------------------------
# Prediction and Evaluation
# ---------------------------

###Prediction
logit_prob <- predict(logit_model, newdata = test_data_scaled, type = "response")
logit_pred <- ifelse(logit_prob > 0.5, 1, 0)
logit_pred <- as.factor(logit_pred)
confusionMatrix(logit_pred, test_data_scaled$HeartDisease)

roc_obj <- roc(test_data_scaled$HeartDisease, logit_prob)
###AUC score
auc(roc_obj)
plot(roc_obj, col = "blue", lwd = 2, main = "ROC Curve - Logistic Regression", print.auc = TRUE, print.auc.col = "red",print.auc.cex = 1.2,legacy.axes = TRUE)

###Optimal threshold and evaluation
best_thresh <- coords(roc_obj, "best", ret = "threshold")$threshold;best_thresh
logit_pred_opt <- as.factor(ifelse(logit_prob > best_thresh, 1, 0))
confusionMatrix(logit_pred_opt, test_data_scaled$HeartDisease)

# ---------------------------
# Visualizing Prediction Probabilities
# ---------------------------

prob_df <- data.frame(Prob = logit_prob, Actual = test_data_scaled$HeartDisease)

ggplot(prob_df, aes(x = Prob, fill = Actual)) +
  geom_histogram(bins = 30, position = "identity", alpha = 0.6) +
  labs(title = "Predicted Probabilities by Actual Outcome",
       x = "Predicted Probability", y = "Count", fill = "Actual Heart Disease") +
  theme_minimal()

# ---------------------------
# Variable Importance Plot
# ---------------------------

importance <- varImp(logit_model, scale = TRUE)

imp_df <- data.frame(Variable = rownames(importance), Importance = importance$Overall)
top_imp <- imp_df %>% arrange(desc(Importance))
color_palette <- hue_pal()(nrow(top_imp))

ggplot(top_imp, aes(x = reorder(Variable, Importance), y = Importance, fill = Variable)) +
  geom_bar(stat = "identity", width = 0.7) +
  coord_flip() +
  geom_text(aes(label = round(Importance, 2)), hjust = -0.2) +
  scale_fill_manual(values = color_palette) +
  labs(title = "Importance of Predictor Variables (GLM)",
       x = "Features", y = "Variable Importance") +
  theme_minimal() +
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5, face = "bold"))
