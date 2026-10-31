
from app.models import Customer, Product, Order, OrderItem


def test_required_tables_exist():
    assert Customer.__tablename__ == "customers"
    assert Product.__tablename__ == "products"
    assert Order.__tablename__ == "orders"
    assert OrderItem.__tablename__ == "order_items"


def test_order_requires_customer():
    foreign_keys = Order.__table__.foreign_keys

    assert any(
        fk.target_fullname == "customers.customer_id"
        for fk in foreign_keys
    )


def test_order_item_has_composite_primary_key():
    primary_key_columns = {
        column.name
        for column in OrderItem.__table__.primary_key.columns
    }

    assert primary_key_columns == {"order_id", "product_id"}
