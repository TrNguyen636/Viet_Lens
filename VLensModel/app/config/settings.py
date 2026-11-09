import os
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(BASE_DIR, '.env')


class Settings(BaseSettings):

    # =====================================================
    # REMOTE INFERENCE & LLM PROVIDERS
    # =====================================================

    PINGGY_URL: str = ""
    GROQ_API_KEY: str = ""

    # =====================================================
    # OPEN WEATHER & SERPAPI
    # =====================================================

    OPENWEATHER_API_KEY: str = ""
    OPENWEATHER_CURRENT_URL: str = "https://api.openweathermap.org/data/2.5/weather"
    OPENWEATHER_FORECAST_URL: str = "https://api.openweathermap.org/data/2.5/forecast"
    OPENWEATHER_GEOCODING_URL: str = "http://api.openweathermap.org/geo/1.0/direct"

    SERPAPI_API_KEY: str = ""

    # =====================================================
    # Pydantic Config
    # =====================================================

    model_config = SettingsConfigDict(
        env_file=ENV_PATH,
        case_sensitive=True,
        extra="ignore"
    )


# =========================================================
# GLOBAL SETTINGS OBJECT
# =========================================================

settings = Settings()

