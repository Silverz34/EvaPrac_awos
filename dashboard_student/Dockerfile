# 1. Base: Usamos una imagen ligera de Linux con Node.js instalado
FROM node:20-alpine

# 2. Directorio de trabajo: Creamos una carpeta '/app' dentro del contenedor
WORKDIR /app

# 3. Copiar dependencias: Pasamos solo el package.json primero
COPY package*.json ./ 

# 4. Instalar: Descargamos las librerías necesarias
RUN npm install

# 5. Copiar código: Ahora sí, pasamos todo tu código (carpetas src, public, etc.) al contenedor
COPY . .

# 6. Construir: Ejecutamos el build de Next.js (crea la carpeta .next)
RUN npm run build

# 7. Arrancar: El comando que mantiene la app viva
CMD ["npm", "start"]