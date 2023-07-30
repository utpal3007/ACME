# Use a base image compatible with the binary architecture (e.g., golang base image)
FROM golang:1.16-alpine

# Copy the binary to the container
COPY eVision-product-ops.linux.1.0.0 /app/eVision-product-ops

# Set the entrypoint to run the binary when the container starts
ENTRYPOINT ["/app/eVision-product-ops"]
