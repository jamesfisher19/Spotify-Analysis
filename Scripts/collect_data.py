# -*- coding: utf-8 -*-
import pandas as pd
import json
import os

json_folder = r'C:\Users\jamis\Desktop\Data Analytics\Projects\Spotify Data\Spotify_Data\Spotify Extended Streaming History'

all_files = [f for f in os.listdir(json_folder) if f.endswith('.json')]

dataframes = []

for file in all_files:
    file_path = os.path.join(json_folder, file)

    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    df = pd.DataFrame(data) 
    dataframes.append(df)   

merged_df = pd.concat(dataframes, ignore_index=True)

merged_df.to_csv(r'C:\Users\jamis\Desktop\Data Analytics\Projects\Spotify Data\Spotify_Data\Spotify Extended Streaming History\spotify_data.csv', index=False)
