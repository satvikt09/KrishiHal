import pandas as pd
import joblib
import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# ---------------- Load Models ----------------
# Crop model + label encoder
rf_model = joblib.load("rf_model.pkl")
le = joblib.load("label_encoder.pkl")

# Fertilizer model + label encoder
fert_model = joblib.load("fertilizer_model.pkl")
fert_le = joblib.load("fertilizer_encoder.pkl")

# ---------------- API KEY ----------------
OPENWEATHER_API_KEY = "f0c02b44c67d8621cdcf8716ce7b92d1"  # replace with your key

# ---------------- Routes ----------------
@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()

        # --- Inputs from user ---
        N = data.get("N")
        P = data.get("P")
        K = data.get("K")
        ph = data.get("ph")
        city = data.get("city")

        if None in [N, P, K, ph, city]:
            return jsonify({"error": "Missing input values"}), 400

        # --- Call weather API ---
        weather_url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={OPENWEATHER_API_KEY}&units=metric"
        weather_res = requests.get(weather_url).json()

        if "main" not in weather_res:
            return jsonify({"error": f"Weather API failed: {weather_res}"}), 400

        temp = weather_res["main"]["temp"]
        rainfall = weather_res.get("rain", {}).get("1h", 0)  # fallback 0 if not available

        # ---------------- Crop Prediction ----------------
        crop_input = pd.DataFrame([{
            "N": N,
            "P": P,
            "K": K,
            "ph": ph,
            "rainfall": rainfall,
            "temperature": temp
        }])

        probs = rf_model.predict_proba(crop_input)[0]
        top3_idx = probs.argsort()[-3:][::-1]
        top3_crops = [le.inverse_transform([i])[0] for i in top3_idx]

        # ---------------- Fertilizer Prediction ----------------
        fert_input = pd.DataFrame([{
            "n": N,
            "p": P,
            "k": K,
            "ph": ph,
            "rainfall": rainfall
        }])

        fert_pred_idx = fert_model.predict(fert_input)[0]
        fert_pred = fert_le.inverse_transform([fert_pred_idx])[0]

        # ---------------- Response ----------------
        return jsonify({
            "top3_crops": top3_crops,
            "recommended_fertilizer": fert_pred,
            "weather": {
                "temperature": temp,
                "rainfall": rainfall
            }
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
