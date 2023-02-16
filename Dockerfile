
# Use an official Node.js runtime as the base image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and yarn.lock to the container
COPY package.json yarn.lock ./

# Install dependencies using Yarn
RUN yarn install

# Copy the rest of the application code to the container
COPY . .

# Set the environment to production
ENV NODE_ENV production

# Expose port 3000 for the Next.js app to listen on
EXPOSE 3000

# Start the Next.js app
CMD [ "yarn", "start" ]
