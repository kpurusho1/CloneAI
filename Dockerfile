FROM node:20-alpine

WORKDIR /app

# Install pnpm
RUN npm install -g pnpm

# Create a dummy tsconfig.tsbuildinfo file to prevent mounting issues
RUN touch tsconfig.tsbuildinfo

# Copy package.json first for better caching
COPY package.json pnpm-lock.yaml* ./

# Install dependencies without frozen lockfile
RUN pnpm install --no-frozen-lockfile

# Copy the rest of the application
COPY . .

# Make sure tsconfig.tsbuildinfo is a regular file, not a directory
RUN rm -f tsconfig.tsbuildinfo && touch tsconfig.tsbuildinfo

# Build the application
RUN pnpm run build

# Set environment variables
ENV NODE_ENV production
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Expose port
EXPOSE 3000

# Start the application
CMD ["pnpm", "start"]
