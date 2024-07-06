import * as fs from "node:fs";

export function loadFromSops(name: string): string {
    const sopsPath = `/run/secrets/` + name;
    if (fs.existsSync(sopsPath)) {
        return fs.readFileSync(sopsPath, 'utf8');
    }
}

export function loadFromEnv(name: string): string {
    const envName = `SECRET_` + name.toUpperCase();
    const secret = process.env[envName];
    if (secret) {
        return secret;
    }
}

let loaders = [
    loadFromEnv,
    loadFromSops
];

export function setLoaders(newLoaders) {
    loaders = newLoaders;
}

export function load(name: string) {


    for (const loader of loaders) {
        const value = loader(name);
        if (value) {

            // If the value starts with "file:", read the file referenced by the path
            if (value.startsWith("file:")) {
                return fs.readFileSync(value.substring(5), 'utf8');
            }

            return value;
        }
    }
}