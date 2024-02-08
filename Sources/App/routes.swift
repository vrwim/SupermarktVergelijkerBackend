import Fluent
import Vapor

func routes(_ app: Application) throws {
    let productController = ProductController()
    app.get("productSuggestions", use: productController.getProductSuggestions)
    app.get("products", use: productController.getProducts)
}

