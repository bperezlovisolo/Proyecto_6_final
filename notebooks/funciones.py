import pandas as pd

def chequeo_inicial(df):
    print("Shape:")
    print(df.shape)
    
    print("Info:")
    print(df.info())
    
    print("Missing values:")
    print(df.isna().sum())
    
    print("Describe (numericas):")
    print(df.describe())
    
    print("Describe (categoricas):")
    print(df.describe(include='object'))

def config_columns(df):
    df = df.copy()
    
    columnas_eliminar = ['Usable Battery (kWh)', 'Real Range (km)', 'Efficiency (Wh/km)', '0–100 km/h (s)', 'Top Speed (km/h)', 'Towing Capacity (kg)', 'Charging Time (min)', 'Max Charging Power (kW)',
        'Horsepower (HP)', 'Torque (Nm)', 'Insurance Rating', 'ADAS Level', 'Usage Type']
    
    df = df.drop(columns=columnas_eliminar)

    df = df.rename(columns={'Model Name': 'model_name', 'Brand': 'brand', 'Body Type': 'body_type', 'Segment': 'segment', 'Price (EUR)': 'price_eur', 'Maintenance Cost (€/year)': 'maintenance_cost_year',
        'Energy Cost (€/100km)': 'energy_cost_100km', 'Seating Capacity': 'seating_capacity', 'Boot Capacity (L)': 'boot_capacity_l', 'Safety Rating (Euro NCAP)': 'safety_rating',
        'Powertrain Type': 'powertrain_type', 'Fuel Type': 'fuel_type'})
    
    return df

def coches_sustentables(df):
    df = df.copy()
    
    df['sustainable'] = df['powertrain_type'].isin(['EV', 'Hybrid']).astype(int)
    
    return df

def costo_anual(df):
    
    df = df.copy()
    km_year = 15000
    
    df['Costo Anual Energ'] = df['Energy Cost (€/100km)'] * (km_year / 100)
    df['Costo Anual total'] = df['Costo Anual Energ'] + df['Maintenance Cost (€/year)']
    
    return df

def familiares(df, min_boot_l=450):

    df = df.copy()

    tipo_coche = ['SUV', 'Crossover', 'Wagon']
    df['coche_familiar'] = ((df['seating_capacity'] >= 5) & (df['body_type'].isin(tipo_coche)) & (df['boot_capacity_l'] >= min_boot_l)).astype(int)
    
    return df

def costes_anuales(df, km_year=15000):

    df = df.copy()

    df["costo_energia_anual"] = df['energy_cost_100km'] * (km_year / 100)
    df['costo_total_anual'] = df['costo_energia_anual'] + df['maintenance_cost_year']

    return df
