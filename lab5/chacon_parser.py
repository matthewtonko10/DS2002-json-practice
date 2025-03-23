import json
import pandas as pd

with open("../data/schacon.repos.json", "r") as file:
	data = json.load(file)

repos = []
for repo in data:
	name = repo["name"]
	html_url = repo["html_url"]
	updated_at = repo["updated_at"]
	visibility = repo["visibility"]
	repos.append([name, html_url, updated_at, visibility])

df = pd.DataFrame(repos, columns=["name", "html_url", "updated_at", "visibility"])

df.head(5).to_csv("chacon.csv", index=False, header=False)
