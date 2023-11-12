function get_lyrics() {
	base="https://api.genius.com"
	token="UyLFAbNJL4e7w4ln6jYRsv6OT1mFd0dQfJ6cuz5I9U0lNHxFvI2h0YAKNrmwxvr2"
	pesquisa="$1"
	
    url=$(curl -s "$base/search?q=${pesquisa// /%20}&access_token=$token" | jq -r '[.response.hits[] | select(.type == "song")][0].result.url')

    {
	python3 <<-EOF
		import re, sys, requests
		from bs4 import BeautifulSoup

		def scrape_song_lyrics(url):
		    page = requests.get(url)
		    html = BeautifulSoup(page.text, 'html.parser')
		    lyrics = html.find('div', {'data-lyrics-container': 'true'}).get_text(separator='\n')
		    lyrics = re.sub(r'[\(\[].*?[\)\]]', '', lyrics)
		    return str(lyrics).strip()

		print(scrape_song_lyrics('$url'))
	EOF
    } 2> /dev/null
}