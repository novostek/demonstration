import React, { useState, useRef, useEffect } from 'react'
import ReactDOM from 'react-dom'
import { useForm } from "react-hook-form";
import M from 'materialize-css'
import EstimateDetail from '../../../src/Estimate/EstimateDetail'
import EstimateProvider from '../../../src/context/Estimate';

const schema = {
  requiredDecimal: { required: true, pattern: /^\d*\.?\d*$/ }
}

const ProductComponent = () => {
  let submitBtnRef = useRef()

  const [productIndex, setProductIndex] = useState({
    productIndex: 0
  })

  const [orderValues, setOrderValues] = useState({})

  const { register, handleSubmit, setValue, errors, reset } = useForm()

  const node = document.getElementById('data')
  const purchases = JSON.parse(node.getAttribute('purchases'))
  const order = JSON.parse(node.getAttribute('order_data'))

  const [productPurchase, setProductPurchase] = useState([])

  useEffect(() => {
    const inicialLoad = async () => {
      purchases.map(purchase => {
        purchase.product_purchases.map((product_purchase, peIndex) => {
          setProductPurchase(productPurchase => {
            const copy = [...productPurchase]
            copy.push({
              key: Math.random(),
              supplier_id: purchase.supplier_id,
              purchase_id: product_purchase.purchase_id,
              product_purchase_id: product_purchase.id,
              name: product_purchase.product ? product_purchase.product.name : product_purchase.custom_title,
              product_id: product_purchase.product_id,
              qty: product_purchase.quantity,
              price: product_purchase.unity_value,
              total: product_purchase.value,
              tax: product_purchase.tax,
              canDelete: false
            })
            return copy
          })
        })
      })
    }
    inicialLoad()

  }, [])

  useEffect(() => {
    const reducer_subtotal = (acc, current) => !current.tax ? parseFloat(acc) + parseFloat(current.total) : parseFloat(acc)
    const reducer_tax = (acc, current) => current.tax ? parseFloat(acc) + parseFloat(current.total) : parseFloat(acc)
    setOrderValues({
      ...orderValues,
      subTotal: productPurchase.reduce(reducer_subtotal, 0),
      tax: productPurchase.reduce(reducer_tax, 0),
    })
  }, [productPurchase])

  useEffect(() => {
    // const node = document.getElementById('order_data')
    const products = JSON.parse(node.getAttribute('products'))

    const autoCompleteProductData = {}

    products.map(product => autoCompleteProductData[product.name] = null)

    const options = {
      data: autoCompleteProductData,
      limit: 5,
      onAutocomplete: (val) => {
        setProductPurchase(productPurchase => {
          const copy = [...productPurchase]
          const { id, name, customer_price, tax } = products.filter(p => p.name === val)[0]
          copy[productIndex.productIndex].product_id = id
          copy[productIndex.productIndex].price = customer_price
          copy[productIndex.productIndex].name = name
          copy[productIndex.productIndex].tax = false
          // {`measurement[${index}].products[${peIndex}].product_id`}
          document.getElementsByName(`products[${productIndex.productIndex}].product_id`)[0].setAttribute('value', id)

          setValue(`products[${productIndex.productIndex}].price`, customer_price)

          return copy
        })
      }
    }

    const elems = document.querySelectorAll('input.autocomplete.autocomplete-products')
    M.Autocomplete.init(elems, options)
  })

  const addProduct = () => {
    const product = {
      key: Math.random(),
      name: '',
      purchase_id: purchases[0].id,
      product_id: null,
      qty: 0,
      price: 0,
      total: 0,
      tax: false,
      canDelete: true
    }
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, index), { ...productEstimate[index], products: [...productEstimate[index].products, product] }, ...productEstimate.slice(index + 1)])
    setProductPurchase(productEstimate => {
      const copy = [...productEstimate]
      copy.push(product)
      return copy
    })
  }

  const removeProduct = async (index, key) => {
    setProductPurchase(productPurchase => {
      const temp = [...productPurchase]

      temp.splice(index, 1)

      reset({
        products: [...temp]
      })

      return temp
    })
  }

  const remoteSubmit = () => {
    submitBtnRef.current.click()
  }

  const create_product_purchase = () => {
    const headers = new Headers()
    headers.append("Accept", "application/json")
    headers.append("Content-Type", "application/json")
    const data = { product_purchase: productPurchase }
    const init = {
      method: 'POST',
      headers,
      body: JSON.stringify(data)
    }
    console.log(data)
    return fetch('/product_purchases', init)
      .then(data => data.json())
  }

  const productTotalPrice = (index, value) => {
    setProductPurchase(productEstimate => {
      const copy = [...productEstimate]

      copy[index].total = (parseFloat(copy[index].qty) * parseFloat(value))
      copy[index].price = value
      setValue(`products[${index}].price`, value)
      setValue(`products[${index}].total`, copy[index].total ? copy[index].total : 0)

      return copy
    })
  }

  const productTotalQty = (index, value) => {
    setProductPurchase(productEstimate => {
      const copy = [...productEstimate]

      copy[index].total = (parseFloat(value) * parseFloat(copy[index].price))
      copy[index].qty = value
      setValue(`products[${index}].qty`, value)
      setValue(`products[${index}].total`, copy[index].total ? copy[index].total : 0)

      return copy
    })
  }

  const onSubmit = data => {
    setProductPurchase(productPurchase => {
      const copy = [...productPurchase]
      return copy.map((product_purchase, index) => {
        return { ...product_purchase, ...data[index] }
      })
    })

    create_product_purchase()
      .then(() => window.location = `/orders/${purchases[0].order_id}`)
  }

  const handleChange = (index, name, value) => {
    setProductPurchase(productEstimate => {
      const copy = [...productEstimate]

      copy[index].name = value
      setValue(name, value)

      return copy
    })
  }

  return (
    <>
      <EstimateDetail />
      <div className="card">
        <div className="card-content">
          <ul className="stepper horizontal stepper-head-only">
            <li className="step ">
              <a href={`/orders/${order.id}/schedule`}>
                <div className="step-title waves-effect">Schedule</div>
              </a>
            </li>

            <li className="step">
              <a href={`/orders/${order.id}/payments`}>
                <div className="step-title waves-effect">Payment</div>
              </a>
            </li>
            <li className="step active">
              <div className="step-title waves-effect">Products purchase</div>
            </li>
          </ul>
          <div className="row products-area-list pl-1 pr-1" id="measurement_proposals" >
            <div className="product-area">
              <div className="products-list" >
                <form onSubmit={handleSubmit(onSubmit)} name="order_form">
                  {
                    productPurchase.map((product_purchase, index) => {
                      return (
                        !product_purchase.tax &&
                        <div className="product" key={index}>
                          <div className="row pl-1 pr-1 products-search">
                            <div className="row">
                              <div className="col s12">
                                <span className="left width-100 pt-1">Product</span>
                                <div 
                                  className="input-field mt-0 mb-0 products-search-field-box">
                                  {/* <a href="#" className="btn-add-product tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a> */}
                                  <input
                                    name={`products[${index}].name`}
                                    ref={register}
                                    onChange={(e) => handleChange(index, e.target.name, e.target.value)}
                                    defaultValue={product_purchase.name}
                                    readOnly={!product_purchase.canDelete}
                                    onClick={() => setProductIndex(prev => {
                                      return { ...prev, productIndex: index }
                                    })}
                                    autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                                  <input
                                    defaultValue={product_purchase.product_id}
                                    name={`products[${index}].product_id`}
                                    ref={register}
                                    autoComplete="off"
                                    type="hidden" />
                                </div>
                                <div className="calc-fields">
                                  <div className="calc-field">
                                    <span className="left width-100 pt-1">Qty.</span>
                                    <input
                                      type="number"
                                      min="0"
                                      step="0.01"
                                      name={`products[${index}].qty`}
                                      defaultValue={product_purchase.qty ? product_purchase.qty : 0.0}
                                      readOnly={!product_purchase.canDelete}
                                      onBlur={(e) => productTotalQty(index, e.target.value)}
                                      ref={register(schema.requiredDecimal)} className="product-value qty" />
                                    {errors.qty && <span>{errors.qty.message}</span>}
                                  </div>
                                  <div className="calc-field">
                                    <span className="left width-100 pt-1">Prince un.</span>
                                    <input
                                      type="number"
                                      min="0"
                                      step="0.01"
                                      name={`products[${index}].price`}
                                      ref={register(schema.requiredDecimal)}
                                      defaultValue={product_purchase.price ? product_purchase.price : 0.0}
                                      readOnly={!product_purchase.canDelete}
                                      onBlur={(e) => productTotalPrice(index, e.target.value)}
                                      className="product-value price" />
                                    {errors.price && <span>{errors.price.message}</span>}
                                  </div>
                                  <div className="calc-field">
                                    <span className="left width-100 pt-1">Total</span>
                                    <input
                                      type="number"
                                      min="0"
                                      step="0.01"
                                      name={`products[${index}].total`}
                                      defaultValue={product_purchase.total ? product_purchase.total : 0.0}
                                      readOnly={!product_purchase.canDelete}
                                      ref={register(schema.requiredDecimal)}
                                      className="product-value total" />
                                    {
                                      product_purchase.canDelete &&
                                      <a onClick={() => removeProduct(index, product_purchase.key)} style={{ cursor: 'pointer' }} className="btn-remove-product"><i className="material-icons">delete</i></a>
                                    }
                                    {errors.total && <span>{errors.total.message}</span>}
                                  </div>
                                </div>
                              </div>
                              
                            </div>
                          </div>
                        </div>
                      )
                    })
                  }
                  <a onClick={() => addProduct()} style={{ height: '30px' }} className="product new-product">
                  </a>
                  <button type="submit" style={{ display: 'none' }} ref={submitBtnRef}></button>
                </form>
              </div>
            </div>
          </div>

          <div className="row">
            <div className="col m5 s12">
            </div>
            <div className="col xl4 m7 s12 offset-xl3">
              <ul>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Subtotal</span>
                  <h6 className="mt-0 subtotal-all">$ {parseFloat(orderValues.subTotal).toFixed(2)}</h6>
                </li>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Tax</span>
                  <h6 className="mt-0 tax-whole">$ {(orderValues.tax ? parseFloat(orderValues.tax).toFixed(2) : 0.0)}</h6>
                </li>
                <li className="divider mt-2 mb-2"></li>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Order Total</span>
                  <h6 className="mt-0 order-total">$ {parseFloat(orderValues.subTotal + (orderValues.tax ? orderValues.tax : 0)).toFixed(2)}</h6>
                </li>
              </ul>
            </div>
          </div>
        </div>

      </div>
      <div className="col s12 pb-2 pr-0 pl-0" style={{ position: 'relative', zIndex: 1 }}>
        <a
          className="btn grey lighten-5 grey-text waves-effect waves-light breadcrumbs-btn left save"
          href={`/orders/${order.id}/payments`}><i className="material-icons left">arrow_back</i> Back</a>
        <a className="btn indigo waves-effect waves-light breadcrumbs-btn right ml-1" onClick={() => remoteSubmit()}><i className="material-icons left">shopping_cart</i> Place Order</a>
      </div>
    </>
  )
}

// export default ProductComponent
document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <EstimateProvider>
      <ProductComponent />
    </EstimateProvider>,
    document.getElementById('react-component'),
  )
})

