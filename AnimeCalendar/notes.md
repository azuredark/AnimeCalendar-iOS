### ScheduleAnime - Screen
- [x] Get `aired.from` (JST-Premiere) to the user's timezone. *Month/Day*
- [x] Add **1 week** starting from `aired.from` (User's Time-Zone)  **until** reaching **past or same day** as the **Date.now**.
- [x] Create *Episodes* based on `episodes` & the # of weeks that fit in until today in case `episodes` is missing.
- [ ] **Concurrently** fetch the episode's info. from `https://api.jikan.moe/v4/anime/49387/episodes`.
- [ ] Make **SelectedTime** part of the *ObservableObject*.
- [ ] Handle **Week-Day** logic for updating watched episodes.
- [ ] Handle **Toggle** switching *on/off* multiple Toggles by previously switched *on*.

