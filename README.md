# 🔥 Anomaly Detection and Attack Prediction from Stateful Firewall Logs


## 🧠 Overview
This project aims to detect anomalies and predict cyber attacks from **stateful firewall logs** using a combination of **supervised** and **unsupervised machine learning techniques**. The goal is to proactively identify malicious activity in network traffic and support automated monitoring pipelines.

The repository includes end-to-end code for:
- Data ingestion & preprocessing
- Feature engineering and exploratory analysis
- Supervised and unsupervised model comparison
- Model training, testing, and prediction
- Integration with visualization and monitoring tools (e.g., Grafana)

All scripts and datasets are contained in the `Codes_Results/` folder.

---

## 🗂 Project Structure
```
.
├── Codes_Results/
│   ├── EDA.ipynb                      # Data exploration and visualization
│   ├── compare_supervised.py          # Compares multiple supervised ML models
│   ├── compare_unsupervised.py        # Evaluates unsupervised anomaly models
│   ├── firewall_log.csv               # Training dataset
│   ├── firewall_test.csv              # Test dataset
│   ├── train_model.py                 # Trains the model and saves joblib file
│   ├── test_model.py                  # Evaluates model performance
│   └── predict.py                     # Predicts anomalies in new data
│
├── models/                            # Generated during training
│   ├── saved_model.joblib             # Serialized ML model (via joblib)
│   └── model_metadata.json            # Metadata for training session
│
├── results/                           # Generated during testing
│   ├── test_metrics.json              # Evaluation metrics (Accuracy, F1, AUROC)
│   ├── test_confusion_matrix.csv      # Confusion matrix for model evaluation
│   └── roc_curve.png                  # ROC curve (optional)
│
├── outputs/                           # Generated predictions
│   └── predictions.csv                # Model output for unseen logs
│
├── requirements.txt
├── README.md
└── LICENSE
```



## 🚀 Script Execution Guide

### 🧩 1. Train Model
```powershell
python Codes_Results/train_model.py --input Codes_Results/firewall_log.csv --output models/saved_model.joblib --seed 42
```
**Performs:**
- Loads and preprocesses firewall logs
- Trains best ML model (e.g., Gradient Boosting)
- Saves trained model and metadata

**Outputs:**
```
models/saved_model.joblib
models/model_metadata.json
```
**Sample Console Output:**
```
Training GradientBoostingClassifier...
F1-macro: 0.89 | Accuracy: 0.91 | AUROC: 0.75
Saved model -> models/saved_model.joblib
```

---

### 🧪 2. Test Model
```powershell
python Codes_Results/test_model.py --model models/saved_model.joblib --test Codes_Results/firewall_test.csv --outdir results
```
**Performs:**
- Loads trained model
- Evaluates on test set
- Saves metrics & confusion matrix

**Outputs:**
```
results/test_metrics.json
results/test_confusion_matrix.csv
```
**Sample Console Output:**
```
Accuracy: 0.91 | F1-macro: 0.89 | AUROC: 0.75
Saved metrics -> results/test_metrics.json
```

---

### 🔮 3. Predict Anomalies
```powershell
python Codes_Results/predict.py --model models/saved_model.joblib --input new_logs.csv --output outputs/predictions.csv
```
**Performs:**
- Loads trained model
- Generates predictions and anomaly scores
- Saves to CSV

**Output Example:**
```
outputs/predictions.csv
```
**Sample Preview:**
```
timestamp,src_ip,dst_ip,src_port,dst_port,protocol,bytes,duration,anomaly_score,pred_label,pred_confidence
2025-11-01 12:00:00,10.0.0.1,192.168.1.2,12345,80,TCP,1024,0.23,0.98,benign,0.95
```

---

## 📊 Model Summary
| Type | Algorithm | F1 | Accuracy | AUROC | Purpose |
|------|------------|----|-----------|--------|----------|
| Supervised | Gradient Boosting | 0.89 | 0.91 | 0.75 | Predict attack classes |
| Unsupervised | Isolation Forest | - | - | 0.74 | Detect anomalies |
