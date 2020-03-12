import React, { useState, useRef, useEffect } from 'react'
import ReactDOM from 'react-dom'
import { useForm } from "react-hook-form";
import M from 'materialize-css'
import * as yup from "yup";
import EstimateDetail from '../EstimateDetail'
import Swal from 'sweetalert2'

const schema = {
  requiredDecimal: { required: true, pattern: /^\d+(\.\d{1,2})?$/ }
}

const ProductComponent = () => {
  let submitBtnRef = useRef()

  const [maProductListIndex, setMaProductListIndex] = useState({
    maIndex: 0,
    productIndex: 0
  })
  const { register, handleSubmit, setValue, reset, errors } = useForm({ mode: "onBlur", reValidateMode: "onSubmit" })

  const node = document.getElementById('estimate_data')
  const estimate = JSON.parse(node.getAttribute('data'))

  const [productEstimate, setProductEstimate] = useState([
    {
      proposal_id: '',
      areas: [],
      products: [
        {
          key: Math.random(),
          name: '',
          product_id: 0,
          qty: 0,
          price: 0,
          discount: 0,
          total: 0
        }
      ]
    }
  ])

  // useEffect(() => {
  //   reset({
  //     measurement: [...productEstimate]
  //   })
  // }, [productEstimate])

  useEffect(() => {
    let indexHelper = 0

    const inicialLoad = async () => {
      if (estimate.measurement_proposals.length > 0) {
        await setProductEstimate(productEstimate => {
          const copy = [...productEstimate]

          copy[0].products.shift()

          return copy
        })

        await Promise.all(
          estimate.measurement_proposals.map((mp, mpIndex) => {
            setProductEstimate(productEstimate => {
              const copy = [...productEstimate]
              if (mp.id !== indexHelper) {
                copy.push({ areas: [], products: [] })
                mp.measurement_area.map(area => copy[mpIndex].areas.push(area.id))
                if (mp.id !== indexHelper) {
                  mp.product_estimates.map((pe, peIndex) => {
                    copy[mpIndex].proposal_id = mp.id
                    copy[mpIndex].products.push({
                      product_estimate_id: pe.id,
                      key: Math.random(),
                      name: pe.name,
                      product_id: pe.product_id,
                      qty: pe.quantity,
                      price: pe.unitary_value,
                      discount: pe.discount,
                      total: pe.value
                    })
                  })
                }

                indexHelper = mp.id
              } else {
                mp.product_estimates.map((pe, peIndex) => {
                  if (copy[mpIndex - 1])
                    copy[mpIndex - 1].products.push({
                      product_estimate_id: pe.id,
                      key: Math.random(),
                      name: pe.name,
                      product_id: pe.product_id,
                      qty: pe.quantity,
                      price: pe.unitary_value,
                      discount: pe.discount,
                      total: pe.value
                    })
                })
                // console.log(copy[])
              }

              return copy
            })
          })
        )
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          copy.pop()

          return copy
        })
      }


    }
    inicialLoad()
  }, [])

  useEffect(() => {

    const node = document.getElementById('estimate_data')
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
          copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].product_id = id
          // {`measurement[${index}].products[${peIndex}].product_id`}
          document.getElementsByName(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}].product_id`)[0].setAttribute('value', id)
          if (productEstimate[maProductListIndex.maIndex].areas.length > 0)
            calculateProductLW(productEstimate[maProductListIndex.maIndex].areas, id)
              .then(result => {
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].qty = result.qty
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].total = result.total
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].price = result.price
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { qty: result.qty })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { price: result.price })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { total: result.total })
              })

          return copy
        })
      }
    }

    const elems = document.querySelectorAll('input.autocomplete.autocomplete-products')
    M.Autocomplete.init(elems, options)
  })

  const calculateProductLW = (areas_ids, product_id) => {
    return fetch(`/calculation_formulas/lxw/product/${product_id}?areas_ids=[${areas_ids}]`)
      .then(data => data.json())
  }

  const addArea = () => {
    const area_product = {
      proposal_id: '',
      areas: [],
      products: [
        {
          key: Math.random(),
          name: '',
          product_id: 0,
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
      key: Math.random(),
      name: '',
      product_id: '',
      qty: 0,
      price: 0,
      discount: 0,
      total: 0
    }
    // console.log(productEstimate[index])
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, index), { ...productEstimate[index], products: [...productEstimate[index].products, product] }, ...productEstimate.slice(index + 1)])
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[index].products.push(product)
      return copy
    })
  }

  const removeProduct = (maIndex, peIndex) => {
    Swal.fire({
      title: 'Are you sure?',
      text: "You won't be able to revert this!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, remove it!',
      cancelButtonText: 'No, cancel!',
      reverseButtons: true
    }).then((result) => {
      if (result.value) {
        const headers = new Headers()
        headers.append("Content-Type", "application/json")
        headers.append("Accept", "application/json")
        const init = {
          method: 'DELETE',
          headers,
        }
        productEstimate[maIndex].products[peIndex].product_estimate_id &&
          fetch(`/product_estimates/${productEstimate[maIndex].products[peIndex].product_estimate_id}`, init)
            .then(res => console.log(res))
            .catch(error => console.log(error))
        Swal.fire(
          'Deleted',
          'Your product has been removed from list.',
          'success'
        )
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          copy[maIndex].products.splice(peIndex, 1)

          return copy
        })
      }
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
    submitBtnRef.current.click()
  }

  const create_product_estimate = () => {
    const headers = new Headers()
    headers.append("Content-Type", "application/json")
    console.log('create', productEstimate)
    const data = { productEstimate }
    const init = {
      method: 'POST',
      headers,
      body: JSON.stringify(data)
    }
    return fetch(`/estimates/${estimate.id}/create_products_estimates`, init)
      .then(data => data.json())
  }

  const removeArea = (index, proposal_id) => {
    Swal.fire({
      title: 'Are you sure?',
      text: "You won't be able to revert this!",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Yes, remove it!',
      cancelButtonText: 'No, cancel!',
      reverseButtons: true
    }).then((result) => {
      if (result.value) {
        const headers = new Headers()
        headers.append("Content-Type", "application/json")
        headers.append("Accept", "application/json")
        const init = {
          method: 'DELETE',
          headers,
        }

        fetch(`/measurement_proposals/${proposal_id}`, init)
          .then(res => console.log(res))
          .catch(error => console.log(error))
        Swal.fire(
          'Deleted',
          'Your proposal has been removed from list.',
          'success'
        )
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          copy.splice(index, 1)

          return copy
        })
      }
    })
  }

  const productTotalPrice = async (maIndex, peIndex, value) => {
    await setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[maIndex].products[peIndex].price = parseFloat(value)
      copy[maIndex].products[peIndex].total = (parseFloat(copy[maIndex].products[peIndex].qty) * parseFloat(value)) - parseFloat(copy[maIndex].products[peIndex].discount)

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? copy[maIndex].products[peIndex].total : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].price`, value ? value : 0)
      return copy
    })
  }

  const productTotalQty = async (maIndex, peIndex, value) => {
    await setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].products[peIndex].qty = parseFloat(value)
      copy[maIndex].products[peIndex].total = (parseFloat(value) * parseFloat(copy[maIndex].products[peIndex].price)) - parseFloat(copy[maIndex].products[peIndex].discount)

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? copy[maIndex].products[peIndex].total : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].qty`, value ? value : 0)
      return copy
    })
  }

  const productTotalDiscount = async (maIndex, peIndex, value) => {
    await setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[maIndex].products[peIndex].discount = parseFloat(value)
      copy[maIndex].products[peIndex].total = (parseFloat(copy[maIndex].products[peIndex].qty) * parseFloat(copy[maIndex].products[peIndex].price)) - parseFloat(value)

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? copy[maIndex].products[peIndex].total : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].discount`, value ? value : 0)
      return copy
    })
  }

  const onSubmit = async data => {
    const copy = [...productEstimate]
    const results = copy.map(async (ma, index) => {
      console.log('map1')
      const maCopy = { ...ma }
      maCopy.products = ma.products.map((pe, peIndex) => {
        console.log('map2')
        return { ...pe, ...data.measurement[index].products[peIndex] }
      })
      return maCopy
    })

    await Promise.all(results).then(async res => {

      await setProductEstimate(res)
    }).then(() => console.log('pos map'))

    create_product_estimate()
      .then(() => window.location = `/estimates/${estimate.id}/view`)
  }

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
              <form onSubmit={handleSubmit(onSubmit)}>
                {
                  productEstimate.map((pe, index) => (
                    <div className="row products-area-list pl-1 pr-1 mt-2" id="measurement_proposals" key={index}>
                      <div className="product-area">
                        <a onClick={() => removeArea(index, pe.proposal_id)} style={{ cursor: 'pointer' }} className="btn-close-product-area"><i className="material-icons">close</i></a>
                        <div className="areas-available col s12">
                          <span>Areas:</span>
                          {
                            estimate.measurement_areas.map((ma, maIndex) => (
                              <div className={`chip ${productEstimate[index].areas.includes(ma.id) ? 'selected' : ''}`} key={Math.random()} onClick={() => !productEstimate[index].areas.includes(ma.id) ? selectArea(index, ma.id, true) : selectArea(index, ma.id, false)}>
                                {ma.name}
                              </div>
                            ))
                          }
                          {/* <a href="#" className="select-all-areas">Select all</a> */}
                        </div>
                        <div className="products-list">

                          <input type="hidden" ref={register} name={`measurement_area[${index}]`} value={index} />
                          {
                            pe.products.map((product, peIndex) => (
                              <div className="product" key={peIndex}>
                                <div className="row pl-1 pr-1 products-search">
                                  <div className="row">
                                    <div className="col s6 m4">
                                      <span className="left width-100 pt-1">Product</span>
                                      <div className="input-field mt-0 mb-0 products-search-field-box">
                                        {/* <a href="#" className="btn-add-product tooltipped" data-tooltip="New product"><i className="material-icons">add</i></a> */}
                                        <input
                                          name="product_list"
                                          ref={register}
                                          defaultValue={productEstimate[index].products[peIndex].name}
                                          onClick={() => setMaProductListIndex(prev => {
                                            return { ...prev, maIndex: index, productIndex: peIndex }
                                          })}
                                          autoComplete="off" type="text" className="autocomplete autocomplete-products mt-1" />
                                        <input
                                          defaultValue={productEstimate[index].products[peIndex].product_id}
                                          name={`measurement[${index}].products[${peIndex}].product_id`}
                                          ref={register}
                                          autoComplete="off"
                                          type="hidden" />
                                      </div>
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Qty.</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].qty`}
                                        defaultValue={productEstimate[index].products[peIndex].qty}
                                        onChange={(e) => productTotalQty(index, peIndex, e.target.value)}
                                        ref={register(schema.requiredDecimal)} className="product-value qty" />
                                      {errors.qty && <span>{errors.qty.message}</span>}
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Prince un.</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].price`}
                                        ref={register(schema.requiredDecimal)}
                                        defaultValue={productEstimate[index].products[peIndex].price}
                                        onChange={(e) => productTotalPrice(index, peIndex, e.target.value)}
                                        className="product-value price" />
                                      {errors.price && <span>{errors.price.message}</span>}
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Discount</span>
                                      <input type="text"
                                        name={`measurement[${index}].products[${peIndex}].discount`}
                                        defaultValue={productEstimate[index].products[peIndex].discount}
                                        onChange={(e) => productTotalDiscount(index, peIndex, e.target.value)}
                                        ref={register(schema.requiredDecimal)}
                                        className="product-value discount" />
                                      {errors.discount && <span>{errors.discount.message}</span>}
                                    </div>
                                    <div className="col s6 m2 calc-fields">
                                      <span className="left width-100 pt-1">Total</span>
                                      <input
                                        type="text"
                                        name={`measurement[${index}].products[${peIndex}].total`}
                                        defaultValue={productEstimate[index].products[peIndex].total}
                                        ref={register(schema.requiredDecimal)}
                                        className="product-value total" />
                                      <a onClick={() => removeProduct(index, peIndex)} style={{ cursor: 'pointer' }} className="btn-remove-product"><i className="material-icons">delete</i></a>
                                      {errors.total && <span>{errors.total.message}</span>}
                                    </div>
                                  </div>
                                </div>
                              </div>
                            ))
                          }
                          <a onClick={() => addProduct(index)} style={{ height: '30px' }} className="product new-product">
                          </a>

                        </div>
                      </div>
                    </div>
                  ))
                }
                <button type="submit" style={{ display: 'none' }} ref={submitBtnRef}></button>
              </form>
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

