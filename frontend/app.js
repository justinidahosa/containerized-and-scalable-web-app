document.getElementById('fetch').addEventListener('click', async () => {
  try {
    const response = await fetch('https://api.justindemo.click/api/hello');
    const data = await response.text();
    document.getElementById('result').textContent = data;
  } catch (err) {
    document.getElementById('result').textContent = 'Error: ' + err.message;
  }
});