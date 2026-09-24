# tab

This repo creates a docker compose environment for running Lute-Tab https://github.com/mandovinnie/Lute-Tab

To use:

```
docker compose build
```

cd into the `work` directory

Use tab with docker compose:
`docker compose run --rm app tab your_file_from_within_the_work_folder`

## Docs
To view the documenation
`docker compose run --rm app man tab`
`docker compose run --rm app less /opt/tab_docs/README`
`docker compose run --rm app less /opt/tab_docs/AboutTab.txt`

## To Dos
* publish the image to github container registry
* make a gha that checks for changes upstream and builds a new image with the latest version
