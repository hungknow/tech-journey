start-web:
	cd ./bindings/wasm; cargo build; npm run build
	-mkdir ./apps/web/generated
	cp ./bindings/wasm/pkg/* ./apps/web/generated/
	cd ./apps/web; python3 -m http.server 7100