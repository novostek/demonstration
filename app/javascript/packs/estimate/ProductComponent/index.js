import React, { useState, useRef } from 'react'
import ReactDOM from 'react-dom'
import { useForm } from "react-hook-form";
import * as yup from "yup";
import EstimateDetail from '../EstimateDetail'

const schema = {
  requiredDecimal: {required:true, pattern: /^\d+(\.\d{1,2})?$/ }
}

const ProductComponent = () => {
  let submitBtnRef = useRef()

  const { register, handleSubmit, errors } = useForm({mode: "onBlur", reValidateMode: "onSubmit"})

  const node = document.getElementById('estimate_data')
  const { estimate } = JSON.parse(node.getAttribute('data'))

  const [productEstimate, setProductEstimate] = useState([
    {
      areas: [],
      products: [
        {
          id: 0,
          key: new Date().getTime(),
          product_id: '',
          qty: 0,
          price: 0.0,
          discount: 0.0,
          total: 0.0
        }
      ]
    }
  ])

  const addArea = () => {
    const area_product = {
      areas: [],
      products: [
        {
          id: 0,
          key: new Date().getTime(),
          product_id: '',
          qty: 0,
          price: 0.0,
          discount: 0.0,
          total: 0.0
        }
      ]
    }
    setProductEstimate(productEstimate => [...productEstimate, area_product])
  }

  const addProduct = (index) => {
    const product = {
      id: 0,
      key: new Date().getTime(),
      product_id: '',
      qty: 0,
      price: 0.0,
      discount: 0.0,
      total: 0.0
    }
    // console.log(productEstimate[index])
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, index), { ...productEstimate[index], products: [...productEstimate[index].products, product] }, ...productEstimate.slice(index + 1)])
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[index].products.push(product)
      return copy
    })
  }

  const removeProduct = (maIndex, key) => {
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].products = copy[maIndex].products.filter(product => product.key !== key)
      console.log(copy[maIndex].products, key)

      return copy
    })
    // setProductEstimate(productEstimate => [
    //   ...productEstimate.slice(0, maIndex), 
    //   { ...productEstimate[maIndex], products: [...productEstimate[maIndex].products.filter(product => product.key !== key)]}])
  }

  const selectArea = (maIndex, area_id, insert) => {
    insert 
    ?
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].areas.push(area_id)
      return copy
    })
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, maIndex), { ...productEstimate[maIndex], areas: [...productEstimate[maIndex].areas, area_id]}])
    :
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].areas = copy[maIndex].areas.filter(area => area !== area_id)
      return copy
    })
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, maIndex), { ...productEstimate[maIndex], areas: [...productEstimate[maIndex].areas.filter(area => area !== area_id)] }])
  }

  const remoteSubmit = () => {
    console.log('remote')
    submitBtnRef.current.click()
  }

  const onSubmit = data => {
    // console.log(data)
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy.map((ma, index) => {
        ma.products.map((pe, peIndex) => data.products[index])
        // copy[index].products[index] = data.products[index]
      })
      return copy
    })
  }

  console.log(productEstimate)

  return (
    <div className="row">
      <div className="col s12">
        <div className="container">
          <EstimateDetail estimate={estimate} />
          <div className="card">
            <div className="card-content">
              <ul className="stepper horizontal stepper-head-only">
                <li className="step">
                  <div className="step-title waves-effect">Step 1</div>
                </li>
                <li className="step ">
                  <div className="step-title waves-effect">Schedule</div>
                </li>
                <li className="step">
                  <div className="step-title waves-effect">Measurements</div>
                </li>
                <li className="step active">
                  <div className="step-title waves-effect">Products</div>
                </li>
              </ul>
              {
                productEstimate.map((pe, index) => (
                  <div className="row products-area-list pl-1 pr-1" id="measurement_proposals" key={index}>
                    <div className="product-area">
                      <a href="#" className="btn-close-product-area"><i className="material-icons">close</i></a>
                      <div className="areas-available col s12">
                        <span>Areas:</span>
                        {
                          estimate.measurement_areas.data.map((ma, maIndex) => (
                            <div className={`chip ${productEstimate[index].areas.includes(ma.id) ? 'selected' : ''}`} key={Math.random()} onClick={() => !productEstimate[index].areas.includes(ma.id) ? selectArea(index, ma.id, true) : selectArea(index, ma.id, false)}>
                              {ma.name}
                            </div>
                          ))
                        }
                        <a href="#" className="select-all-areas">Select all</a>
                      </div>
                      <div className="products-list">
                        <form onSubmit={handleSubmit(onSubmit)}>
                          <input type="hidden" ref={register} name={`measurement_area[${index}]`} value={index}/>
                        {
                          pe.products.map((product, peIndex) => (
                            <div className="product" key={peIndex}>
                              <div className="row pl-1 pr-1 products-search">
                                <div className="row">
                                  <div className="col s6 m4">
                                    <span className="left width-100 pt-1">Product</span>
                                    <div className="input-field mt-0 mb-0 products-search-field-box">
                                      <a href="#" className="btn-add-product tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a>
                                      <input name="product_list" ref={register} autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                                      <input name={`products[${index}].product_id`} ref={register} autoComplete="off" type="hidden"/>
                                    </div>
                                  </div>
                                  <div className="col s6 m2 calc-fields">
                                    <span className="left width-100 pt-1">Qty.</span>
                                    <input type="text" name={`products[${index}].qty`} ref={register(schema.requiredDecimal)} className="product-value qty" />
                                    {errors.qty && <span>{errors.qty.message}</span>}
                                  </div>
                                  <div className="col s6 m2 calc-fields">
                                    <span className="left width-100 pt-1">Prince un.</span>
                                    <input type="text" name={`products[${index}].price`} ref={register(schema.requiredDecimal)} className="product-value price" />
                                    {errors.price && <span>{errors.price.message}</span>}
                                  </div>
                                  <div className="col s6 m2 calc-fields">
                                    <span className="left width-100 pt-1">Discount</span>
                                    <input type="text" name={`products[${index}].discount`} ref={register(schema.requiredDecimal)} className="product-value discount" />
                                    {errors.discount && <span>{errors.discount.message}</span>}
                                  </div>
                                  <div className="col s6 m2 calc-fields">
                                    <span className="left width-100 pt-1">Total</span>
                                    <input type="text" name={`products[${index}].total`} ref={register(schema.requiredDecimal)} className="product-value total" />
                                    <a onClick={() => removeProduct(index, product.key)} style={{cursor: 'pointer'}} className="btn-remove-product"><i className="material-icons">delete</i></a>
                                    {errors.total && <span>{errors.total.message}</span>}
                                  </div>
                                </div>
                              </div>
                              <div onClick={() => addProduct(index)} className="product new-product">
                                <span>teste</span>
                              </div>
                            </div>
                          ))
                        }
                        <button type="submit" style={{display: 'none'}} ref={submitBtnRef}></button>
                        </form>
                      </div>
                    </div>
                  </div>
                ))
              }
              <div className="row mt-1">
                <a onClick={addArea} className="btn btn-add-product-area"><i className="material-icons left">add</i> Add area</a>
              </div>

              <div className="products-suggestions hide">
                <h6 className="suggestions-title">Suggestions</h6>
                <a href="#" data-price="56.9" data-qty="3">Product with a big name</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y2</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y3</a>
                <a href="#" data-price="23.1" data-qty="1">Product Y5</a>
              </div>
            </div>

          </div>
        </div>
      </div>
      <div className="col s12 pb-2 pr-0 pl-0" style={{ position: 'relative', zIndex: 1 }}>
        <a className="btn grey lighten-5 grey-text waves-effect waves-light breadcrumbs-btn left save" href="estimate-measurements.html"><i className="material-icons left">arrow_back</i> Back</a>
        <a className="btn indigo waves-effect waves-light breadcrumbs-btn right ml-1" onClick={() => remoteSubmit()}><i className="material-icons left">save</i> Save</a>
      </div>
    </div>
  )
}

// export default ProductComponent
document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <ProductComponent />,
    document.getElementById('react-component'),
  )
})

