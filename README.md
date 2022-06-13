# crafting_recipes
[![Crafting Recipes](https://circleci.com/gh/hamsoft-io/crafting_recipes.svg?style=svg)](https://app.circleci.com/pipelines/github/hamsoft-io/crafting_recipes)

A simple CLI tool that creates crafting jobs


Testing:
    bin/rspec --format doc

Docker image build:
    make image

Docker run (build image first):
    make run

Example usage (not implemented yet):
    ruby craft_items.rb