# Use a base image with Elixir and Erlang/OTP pre-installed
FROM elixir:1.12-alpine AS build

# Set environment variables
ENV MIX_ENV=prod \
    LANG=C.UTF-8

# Install build dependencies
RUN apk add --no-cache build-base npm git

# Create and set working directory
WORKDIR /app

# Copy the mix.exs and mix.lock files to the container
COPY mix.* ./

# Install dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

# Copy the remaining application files and compile the application
COPY . .
RUN npm install --prefix ./assets && \
    npm run deploy --prefix ./assets && \
    mix compile && \
    mix phx.digest && \
    mix release

# Create a new image that contains only the release
FROM alpine:3.14 AS app

# Install runtime dependencies
RUN apk add --no-cache bash openssl

# Set environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    MIX_ENV=prod \
    REPLACE_OS_VARS=true

# Copy the release from the previous image
COPY --from=build /app/_build/prod/rel/core ./

# Set the default command
CMD ["bin/core", "start"]

# Expose the Phoenix web server port
EXPOSE 4000