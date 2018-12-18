Feature: Site Smoke Test
Scenario:
  Given We navigate to the homepage
  When We search for the title Game of Life
  Then The title for the homepage will be displayed
