from openai import OpenAI
import os

client = OpenAI(
  base_url = "https://integrate.api.nvidia.com/v1",
  api_key = os.environ.get('NVIDIA_API_KEY')
)

completion = client.chat.completions.create(
  model="nvidia/llama-3.1-nemotron-ultra-253b-v1",
  messages=[{"role":"user","content":"what is 1 + 1"}],
)

for chunk in completion:
  if chunk.choices[0].delta.content is not None:
    print(chunk.choices[0].delta.content, end="")

