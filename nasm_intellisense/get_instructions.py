import requests
from bs4 import BeautifulSoup

url = "https://www.felixcloutier.com/x86/"

try:
    response = requests.get(url)
    response.raise_for_status()

    soup = BeautifulSoup(response.content, 'html.parser')

    # Tìm tất cả thẻ <h2>
    all_h2 = soup.find_all('h2')

    for h2 in all_h2:
        section_title = h2.get_text().strip()
        print(f"\n=== {section_title} ===")

        # Lấy phần tử tiếp theo ngay sau <h2> (có thể là <ul>, <div>, hoặc <p>)
        next_element = h2.find_next_sibling()

        # Tìm tất cả các thẻ <a> bên trong phần tử tiếp theo (nếu có)
        if next_element:
            commands = next_element.find_all('a')
            for cmd in commands:
                mnemonic = cmd.get_text().strip()
                if mnemonic:
                    print(f"{mnemonic}|",end="")
        else:
            print("No instruction list found.")

except requests.exceptions.RequestException as e:
    print(f"Error fetching the URL: {e}")
except Exception as e:
    print(f"An error occurred: {e}")
