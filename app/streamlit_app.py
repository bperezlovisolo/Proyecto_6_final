import streamlit as st
import pandas as pd
import altair as alt

st.set_page_config(page_title="Buscador de coches familiares", layout="wide")

@st.cache_data
def load_data():
    df = pd.read_csv("data/cars_analysis_final.csv")
    return df

df = load_data()

st.title("Buscador de vehículos familiares accesibles en España")
st.markdown("""Explora qué vehículos familiares pueden ser accesibles para tu hogar según ingreso anual, necesidades de espacio y características del vehículo.""")

st.sidebar.header("Filtros")

ingreso_anual = st.sidebar.slider("Ingreso anual del hogar (€)", min_value=20000, max_value=80000, value=34716, step=1000)

plazas_min = st.sidebar.slider("Número mínimo de plazas", min_value=int(df["seating_capacity"].min()), max_value=int(df["seating_capacity"].max()), value=5, step=1)

maletero_min = st.sidebar.slider("Capacidad mínima de maletero (L)", min_value=int(df["boot_capacity_l"].min()), max_value=int(df["boot_capacity_l"].max()), value=450, step=10)

safety_min = st.sidebar.slider("Safety rating mínimo", min_value=float(df["safety_rating"].min()), max_value=float(df["safety_rating"].max()), value=4.0, step=0.5)

powertrain_options = ["Todas"] + sorted(df["powertrain_type"].dropna().unique().tolist())
powertrain_selected = st.sidebar.selectbox("Tipo de tecnología", options=powertrain_options)

solo_sostenibles = st.sidebar.checkbox("Solo vehículos sostenibles", value=False)

solo_accesibles = st.sidebar.checkbox("Solo coches accesibles para mi ingreso", value=False)

df_filtered = df.copy()
df_filtered["ratio_precio_ingreso_usuario"] = df_filtered["price_eur"] / ingreso_anual
df_filtered["ratio_tco_ingreso_usuario"] = df_filtered["cto_5y"] / ingreso_anual


df_filtered = df_filtered[(df_filtered["coche_familiar"] == 1) & (df_filtered["seating_capacity"] >= plazas_min) & (df_filtered["boot_capacity_l"] >= maletero_min) & (df_filtered["safety_rating"] >= safety_min)]

if powertrain_selected != "Todas":
    df_filtered = df_filtered[df_filtered["powertrain_type"] == powertrain_selected]

if solo_sostenibles:
    df_filtered = df_filtered[df_filtered["sustainable"] == 1]

if solo_accesibles:
    df_filtered = df_filtered[df_filtered["ratio_precio_ingreso_usuario"] <= 0.8]

if df_filtered.empty:
    st.warning("No se encontraron vehículos con los filtros seleccionados.")
else:
    st.subheader("Resumen de resultados")

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Vehículos encontrados", len(df_filtered))
    col2.metric("Precio medio (€)", f"{df_filtered['price_eur'].mean():,.0f}")
    col3.metric("Coste anual medio (€)", f"{df_filtered['costo_total_anual'].mean():,.0f}")
    col4.metric("TCO 5 años medio (€)", f"{df_filtered['cto_5y'].mean():,.0f}")

    st.subheader("Vehículos encontrados")

    tabla_resultados = (
        df_filtered[
            [
                "brand",
                "model_name",
                "powertrain_type",
                "price_eur",
                "costo_total_anual",
                "cto_5y",
                "safety_rating",
                "boot_capacity_l",
                "seating_capacity",
                "ratio_precio_ingreso_usuario",
            ]
        ]
        .sort_values("ratio_precio_ingreso_usuario", ascending=True)
        .rename(columns={
            "brand": "Marca",
            "model_name": "Modelo",
            "powertrain_type": "Tecnología",
            "price_eur": "Precio (€)",
            "costo_total_anual": "Costo anual (€)",
            "cto_5y": "CTO 5 años (€)",
            "safety_rating": "Seguridad",
            "boot_capacity_l": "Maletero (L)",
            "seating_capacity": "Plazas",
            "ratio_precio_ingreso_usuario": "Ratio precio/ingreso"
        })
    )

    st.dataframe(tabla_resultados, use_container_width=True)

    st.subheader("Distribución por tecnología")
    powertrain_counts = df_filtered["powertrain_type"].value_counts()
    st.bar_chart(powertrain_counts)

    st.subheader("Precio vs Coste total de propiedad (5 años)")

scatter = (
    alt.Chart(df_filtered)
    .mark_circle(size=80)
    .encode(
        x=alt.X("price_eur", title="Precio del vehículo (€)"),
        y=alt.Y("cto_5y", title="Costo total 5 años (€)"),
        color=alt.Color("powertrain_type", title="Motorización"),
        tooltip=[
            "brand",
            "model_name",
            "powertrain_type",
            "price_eur",
            "cto_5y",
        ],
    )
    .interactive()
)

st.altair_chart(scatter, use_container_width=True)