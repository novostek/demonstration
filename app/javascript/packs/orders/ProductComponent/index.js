import React, { useState, useRef, useEffect } from 'react'
import ReactDOM from 'react-dom'
import { useForm } from "react-hook-form";
import M from 'materialize-css'
import * as yup from "yup";
import EstimateDetail from '../../estimate/EstimateDetail'

const schema = {
  requiredDecimal: { required: true, pattern: /^\d+(\.\d{1,2})?$/ }
}

const ProductComponent = () => {
  let submitBtnRef = useRef()

  const [productIndex, setProductIndex] = useState({
    productIndex: 0
  })

  const [orderValues, setOrderValues] = useState({})

  const { register, handleSubmit, setValue, errors } = useForm({ mode: "onBlur", reValidateMode: "onSubmit" })

  const node = document.getElementById('order_data')
  const order = JSON.parse(node.getAttribute('data'))
  const estimate = JSON.parse(node.getAttribute('estimate'))

  const [productEstimate, setProductEstimate] = useState([])

  useEffect(() => {
    const total = productEstimate
    const reducer_subtotal = (acc, current) => parseFloat(acc) + parseFloat(current.total)
    const reducer_discount = (acc, current) => parseFloat(acc) + parseFloat(current.discount)
    const reducer_tax = (acc, current) => parseFloat(acc) + parseFloat(current.tax)

    setOrderValues({
      ...orderValues,
      subTotal: total.reduce(reducer_subtotal, 0),
      discount: total.reduce(reducer_discount, 0),
      tax: total.reduce(reducer_tax, 0),
    })

  }, [productEstimate])

  useEffect(() => {
    const inicialLoad = async () => {
      if (order.product_estimates.length > 0) {
        await Promise.all(
          order.product_estimates.map((pe, peIndex) => {
            setProductEstimate(productEstimate => {
              const copy = [...productEstimate]
              copy.push({
                key: Math.random(),
                name: pe.name,
                product_id: pe.product_id,
                qty: pe.quantity,
                price: pe.unitary_value,
                discount: pe.discount,
                total: pe.value
              })
              return copy
            })
          })
        )
      }
    }
    inicialLoad()

  }, [])

  useEffect(() => {

    const node = document.getElementById('order_data')
    const products = JSON.parse(node.getAttribute('products'))

    const autoCompleteProductData = {}

    products.map(product => autoCompleteProductData[product.name] = null)

    const options = {
      data: autoCompleteProductData,
      limit: 5,
      onAutocomplete: (val) => {
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          const id = products.filter(p => p.name === val)[0].id
          copy[productIndex.productIndex].product_id = id
          // {`measurement[${index}].products[${peIndex}].product_id`}
          document.getElementsByName(`products[${productIndex.productIndex}].product_id`)[0].setAttribute('value', id)

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
      product_id: 0,
      qty: 0,
      price: 0,
      discount: 0,
      total: 0
    }
    // console.log(productEstimate[index])
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, index), { ...productEstimate[index], products: [...productEstimate[index].products, product] }, ...productEstimate.slice(index + 1)])
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy.push(product)
      return copy
    })

    console.log(productEstimate)
  }

  const removeProduct = (key) => {
    const temp = [...productEstimate]

    temp.splice(key, 1)

    setProductEstimate(temp)
  }

  const remoteSubmit = () => {
    submitBtnRef.current.click()
  }

  const create_product_estimate = () => {
    const headers = new Headers()
    headers.append("Content-Type", "application/json")
    console.log('create')
    const data = { productEstimate }
    const init = {
      method: 'POST',
      headers,
      body: JSON.stringify(data)
    }
    return fetch('/estimates/product_estimate', init)
      .then(data => data.json())
  }

  const productTotalPrice = (index, value) => {
    console.log("change", index, value)
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[index].total = (parseFloat(copy[index].qty) * parseFloat(value)) - parseFloat(copy[index].discount)

      setValue(`products[${index}].total`, copy[index].total ? copy[index].total : 0)

      return copy
    })
  }

  const productTotalQty = (index, value) => {
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[index].total = (parseFloat(value) * parseFloat(copy[index].price)) - parseFloat(copy[index].discount)

      setValue(`products[${index}].total`, copy[index].total ? copy[index].total : 0)

      return copy
    })
  }

  const productTotalDiscount = (index, value) => {
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[index].total = (parseFloat(copy[index].qty) * parseFloat(copy[index].price)) - parseFloat(value)

      setValue(`products[${index}].total`, copy[index].total ? copy[index].total : 0)

      return copy
    })
  }

  console.log(estimate)

  const onSubmit = data => {
    // setProductEstimate(productEstimate => {
    //   const copy = [...productEstimate]
    //   return copy.map((ma, index) => {
    //     const maCopy = { ...ma }
    //     maCopy.products = ma.products.map((pe, peIndex) => {
    //       return { ...pe, ...data.measurement[index].products[peIndex] }
    //     })
    //     return maCopy
    //   })
    // })

    // create_product_estimate()
    //   .then(() => window.location = `/estimates/${order.id}/view`)
  }

  // console.log("ORDER", order)
  // console.log("productEstimate", productEstimate)
  // console.log('orderValues', orderValues)

  return (
    <>
      <EstimateDetail estimate={estimate} />
      <div className="card">
        <div className="card-content">
          <ul className="stepper horizontal stepper-head-only">
            <li className="step ">
              <div className="step-title waves-effect">Schedule</div>
            </li>
            <li className="step">
              <div className="step-title waves-effect">Payment</div>
            </li>
            <li className="step active">
              <div className="step-title waves-effect">Products purchase</div>
            </li>
          </ul>
          <div className="row products-area-list pl-1 pr-1" id="measurement_proposals" >
            <div className="product-area">
              <div className="products-list" >
                <form onSubmit={handleSubmit(onSubmit)}>
                  {
                    productEstimate.map((pe, index) => (
                      <div className="product" key={index}>
                        <div className="row pl-1 pr-1 products-search">
                          <div className="row">
                            <div className="col s6 m4">
                              <span className="left width-100 pt-1">Product</span>
                              <div className="input-field mt-0 mb-0 products-search-field-box">
                                {/* <a href="#" className="btn-add-product tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a> */}
                                <input
                                  name="product_list"
                                  ref={register}
                                  defaultValue={productEstimate[index].name}
                                  onClick={() => setProductIndex(prev => {
                                    return { ...prev, productIndex: index }
                                  })}
                                  autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                                <input
                                  defaultValue={productEstimate[index].product_id}
                                  name={`products[${index}].product_id`}
                                  ref={register}
                                  autoComplete="off"
                                  type="hidden" />
                              </div>
                            </div>
                            <div className="col s6 m2 calc-fields">
                              <span className="left width-100 pt-1">Qty.</span>
                              <input
                                type="text"
                                name={`products[${index}].qty`}
                                defaultValue={productEstimate[index].qty}
                                onChange={(e) => productTotalQty(index, e.target.value)}
                                ref={register(schema.requiredDecimal)} className="product-value qty" />
                              {errors.qty && <span>{errors.qty.message}</span>}
                            </div>
                            <div className="col s6 m2 calc-fields">
                              <span className="left width-100 pt-1">Prince un.</span>
                              <input
                                type="text"
                                name={`products[${index}].price`}
                                ref={register(schema.requiredDecimal)}
                                defaultValue={productEstimate[index].price}
                                onChange={(e) => productTotalPrice(index, e.target.value)}
                                className="product-value price" />
                              {errors.price && <span>{errors.price.message}</span>}
                            </div>
                            <div className="col s6 m2 calc-fields">
                              <span className="left width-100 pt-1">Discount</span>
                              <input type="text"
                                name={`products[${index}].discount`}
                                defaultValue={productEstimate[index].discount}
                                onChange={(e) => productTotalDiscount(index, e.target.value)}
                                ref={register(schema.requiredDecimal)}
                                className="product-value discount" />
                              {errors.discount && <span>{errors.discount.message}</span>}
                            </div>
                            <div className="col s6 m2 calc-fields">
                              <span className="left width-100 pt-1">Total</span>
                              <input
                                type="text"
                                name={`products[${index}].total`}
                                defaultValue={productEstimate[index].total}
                                ref={register(schema.requiredDecimal)}
                                className="product-value total" />
                              <a onClick={() => removeProduct(pe.key)} style={{ cursor: 'pointer' }} className="btn-remove-product"><i className="material-icons">delete</i></a>
                              {errors.total && <span>{errors.total.message}</span>}
                            </div>
                          </div>
                        </div>
                      </div>
                    ))
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
                  <h6 className="mt-0 subtotal-all">{orderValues.subTotal}</h6>
                </li>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Discount</span>
                  <h6 className="mt-0 discount-all">{orderValues.discount}</h6>
                </li>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Tax</span>
                  <h6 className="mt-0 tax-whole">{(orderValues.tax ? orderValues.tax : 0)}</h6>
                </li>
                <li className="divider mt-2 mb-2"></li>
                <li className="display-flex justify-content-between">
                  <span className="invoice-subtotal-title">Order Total</span>
                  <h6 className="mt-0 order-total">$ {orderValues.subTotal - orderValues.discount + (orderValues.tax ? orderValues.tax : 0)}</h6>
                </li>
              </ul>
            </div>
          </div>
        </div>

      </div>
      <div className="col s12 pb-2 pr-0 pl-0" style={{ position: 'relative', zIndex: 1 }}>
        <a className="btn grey lighten-5 grey-text waves-effect waves-light breadcrumbs-btn left save" href="estimate-measurements.html"><i className="material-icons left">arrow_back</i> Back</a>
        <a className="btn indigo waves-effect waves-light breadcrumbs-btn right ml-1" onClick={() => remoteSubmit()}><i className="material-icons left">save</i> Save</a>
      </div>
    </>
  )
}

// export default ProductComponent
document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ProductComponent />,
    document.getElementById('react-component'),
  )
})

