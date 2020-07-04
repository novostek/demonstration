import React, { createContext, useState, useEffect, useRef } from 'react'
import { useForm } from 'react-hook-form'
import axios from 'axios'
import Swal from 'sweetalert2'
export const EstimateContext = createContext()

export default function EstimateProvider({children}) {
  const schema = {
    requiredDecimal: { required: true, pattern: /^\d*\.?\d*$/ }
  }

  const node = document.getElementById('data')
  const estimateData = JSON.parse(node.getAttribute('estimate_data'))

  const submitBtnRef = useRef()

  const [suggestions, setSuggestions] = useState([{
    area_id: 0,
    suggestions: []
  }])

  const [estimate, setEstimate] = useState(estimateData)

  const [productEstimate, setProductEstimate] = useState([
    {
      proposal_id: '',
      showSuggestions: false,
      areas: estimate.measurement_areas.map(ma => ma.id),
      toggleSelect: false,
      products: [
        {
          key: Math.random(),
          name: '',
          product_id: 0,
          qty: 0,
          price: 0,
          discount: 0,
          tax: false,
          total: 0
        }
      ]
    }
  ])

  const [productAutoComplete, setProductAutoComplete] = useState({})

  const [maProductListIndex, setMaProductListIndex] = useState({
    maIndex: 0,
    productIndex: 0
  })

  const { register, handleSubmit, setValue, reset, errors } = useForm({ mode: "onBlur", reValidateMode: "onSubmit" })

  const updateProductList = async (index, peIndex, name, value) => {
    const { data: products } = await axios.get('/products.json')

    setProductAutoComplete(products)
  }

  const updateSuggestions = async (area, product_id) => {
    const { data } = await axios.get(`/products/${product_id}.json`)
    setSuggestions((suggestions) => {
      const copy = [...suggestions]
      copy.push({
        area_id: 0,
        suggestions: []
      })
      const suggestions_ids = copy[area].suggestions.map(obj => obj.id)

      data.suggestions.map((suggestion_data, index) => {
        if (!suggestions_ids.includes(suggestion_data.id))
          copy[area].suggestions.push({ ...suggestion_data })
      })

      return copy
    })


  }

  const addSuggestionsToProductList = async (area_index, suggestion) => {
    await addProduct(area_index)
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      const product_index = productEstimate[area_index].products.length - 1

      setSuggestions(suggestion_state => {
        const temp = [...suggestion_state]

        temp[area_index].suggestions = temp[area_index].suggestions.filter(s => s.id !== suggestion.id)

        return temp
      })


      if (productEstimate[area_index].areas.length > 0)
        calculateProductLW(productEstimate[area_index].areas, suggestion.id)
          .then(result => {
            // copy[area_index].products[product_index].product_id = result.id
            copy[area_index].products[product_index].product_id = result.id
            copy[area_index].products[product_index].name = result.name
            copy[area_index].products[product_index].qty = result.qty
            copy[area_index].products[product_index].total = result.total
            copy[area_index].products[product_index].price = result.price
            copy[area_index].products[product_index].tax = result.tax
            setValue(`measurement[${area_index}].products[${product_index}]`, { product_id: result.id })
            setValue(`measurement[${area_index}].products[${product_index}]`, { name: result.name })
            setValue(`measurement[${area_index}].products[${product_index}]`, { qty: result.qty })
            setValue(`measurement[${area_index}].products[${product_index}]`, { price: result.price })
            setValue(`measurement[${area_index}].products[${product_index}]`, { tax: result.tax })
            setValue(`measurement[${area_index}].products[${product_index}]`, { total: result.total })
          })
      else {
        copy[area_index].products[product_index].product_id = suggestion.id
        copy[area_index].products[product_index].name = suggestion.name
        copy[area_index].products[product_index].qty = 0
        copy[area_index].products[product_index].total = 0
        copy[area_index].products[product_index].price = suggestion.unitary_value
        copy[area_index].products[product_index].tax = suggestion.tax
        setValue(`measurement[${area_index}].products[${product_index}]`, { product_id: suggestion.id })
        setValue(`measurement[${area_index}].products[${product_index}]`, { name: suggestion.name })
        setValue(`measurement[${area_index}].products[${product_index}]`, { qty: 0 })
        setValue(`measurement[${area_index}].products[${product_index}]`, { price: suggestion.customer_price })
        setValue(`measurement[${area_index}].products[${product_index}]`, { tax: suggestion.tax })
        setValue(`measurement[${area_index}].products[${product_index}]`, { total: 0 })
      }
      return copy
    })
  }

  useEffect(() => {
    let indexHelper = 0

    const initialLoad = async () => {
      const { data: products } = await axios.get('/products.json')
      setProductAutoComplete(products)
      setSuggestions([{
        area_id: 999,
        suggestions: [{}]
      }])

      if (estimate.measurement_proposals.length > 0) {
        await setProductEstimate(productEstimate => {
          const copy = [...productEstimate]

          copy[0].products.shift()

          return copy
        })

        await Promise.all(
          estimate.measurement_proposals.map((mp, mpIndex) => {
            const suggestions_obj = {
              area_id: 0,
              suggestions: []
            }

            setSuggestions(suggestions => [...suggestions, suggestions_obj])
            setProductEstimate(productEstimate => {
              const copy = [...productEstimate]
              if (mp.id !== indexHelper) {
                copy.push({ areas: [], products: [] })
                mp.measurement_area.map(area => {
                  // selectArea(mpIndex, area.id, insert)
                  copy[mpIndex].areas.push(area.id)
                })
                if (mp.id !== indexHelper) {
                  copy[mpIndex].proposal_id = mp.id
                  mp.product_estimates.map((pe, peIndex) => {
                    copy[mpIndex].toggleSelect = false
                    copy[mpIndex].products.push({
                      product_estimate_id: pe.id,
                      key: Math.random(),
                      name: pe.name,
                      product_id: pe.product_id,
                      qty: pe.quantity,
                      price: pe.unitary_value,
                      discount: pe.discount,
                      tax: pe.tax,
                      total: pe.value,
                      readOnly: true
                    })
                  })
                }

                indexHelper = mp.id
              } else {
                mp.product_estimates.map((pe, peIndex) => {
                  if (copy[mpIndex - 1]){                    
                    copy[mpIndex].toggleSelect = false
                    copy[mpIndex - 1].products.push({
                      product_estimate_id: pe.id,
                      key: Math.random(),
                      name: pe.name,
                      product_id: pe.product_id,
                      qty: pe.quantity,
                      price: pe.unitary_value,
                      discount: pe.discount,
                      tax: pe.tax,
                      total: pe.value,
                      readOnly: true
                    })
                  }
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
    initialLoad()
  }, [])

  useEffect(() => {
    const autoCompleteProductData = {}

    Array.isArray(productAutoComplete) && productAutoComplete.map(product => autoCompleteProductData[product.name] = null)

    const options = {
      data: autoCompleteProductData,
      limit: 5,
      onAutocomplete: (val) => {
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          const id = productAutoComplete.filter(p => p.name === val)[0].id
          updateSuggestions(maProductListIndex.maIndex, id)

          copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].product_id = id
          copy[maProductListIndex.maIndex].showSuggestions = true
          // {`measurement[${index}].products[${peIndex}].product_id`}
          document.getElementsByName(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}].product_id`)[0].setAttribute('value', id)
          if (productEstimate[maProductListIndex.maIndex].areas.length > 0)
            calculateProductLW(productEstimate[maProductListIndex.maIndex].areas, id)
              .then(result => {
                console.log(result)
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].product_id = result.id
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].name = result.name
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].qty = result.qty
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].total = result.total
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].price = result.price
                copy[maProductListIndex.maIndex].products[maProductListIndex.productIndex].tax = result.tax
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { product_id: result.id })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { name: result.name })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { qty: result.qty })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { price: result.price })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { tax: result.tax })
                setValue(`measurement[${maProductListIndex.maIndex}].products[${maProductListIndex.productIndex}]`, { total: result.total })
              })

          return copy
        })
      }
    }

    const elems = document.querySelectorAll('input.autocomplete.autocomplete-products')
    M.Autocomplete.init(elems, options)
  }, [productAutoComplete])

  const calculateProductLW = (areas_ids, product_id) => {
    const headers = new Headers()
    headers.append("Content-Type", "application/json")
    const init = {
      method: 'POST',
      headers,
      body: JSON.stringify({areas : areas_ids})
    }
    return fetch(`/calculation_formulas/lxw/product/${product_id}`, init)
      .then(data => data.json())
  }

  const addArea = () => {
    const area_product = {
      proposal_id: '',
      areas: [],
      toggleSelect: false,
      products: [
        {
          key: Math.random(),
          name: '',
          product_id: 0,
          qty: 0,
          price: 0.0,
          discount: 0.0,
          tax: false,
          total: 0.0
        }
      ]
    }

    estimate.measurement_areas.map((ma) => {
      area_product.areas.push(ma.id)
    })

    setProductEstimate(productEstimate => [...productEstimate, area_product])
  }

  const addProduct = async (index) => {
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
    await setProductEstimate(productEstimate => {
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
            .then(res => {})
            .catch(error => console.log(error))
        Swal.fire(
          'Deleted',
          'Your product has been removed from list.',
          'success'
        )
        setProductEstimate(productEstimate => {
          const copy = [...productEstimate]
          copy[maIndex].products.splice(peIndex, 1)

          reset(copy)

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
    document.forms['tax_form'].reportValidity()
    &&
    submitBtnRef.current.click() 
  }

  const refreshArea = (proposal_id) => {
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[proposal_id].areas.length > 0
        &&
        copy[proposal_id].products.map((product, index) => {
          product.product_id
            &&
            calculateProductLW(copy[proposal_id].areas, product.product_id)
              .then(result => {
                // copy[proposal_id].products[product_index].product_id = result.id
                copy[proposal_id].products[index].product_id = result.id
                copy[proposal_id].products[index].name = result.name
                copy[proposal_id].products[index].qty = result.qty
                copy[proposal_id].products[index].total = result.total
                copy[proposal_id].products[index].price = result.price
                copy[proposal_id].products[index].tax = result.tax
                setValue(`measurement[${proposal_id}].products[${index}]`, { product_id: result.id })
                setValue(`measurement[${proposal_id}].products[${index}]`, { name: result.name })
                setValue(`measurement[${proposal_id}].products[${index}]`, { qty: result.qty })
                setValue(`measurement[${proposal_id}].products[${index}]`, { price: result.price })
                setValue(`measurement[${proposal_id}].products[${index}]`, { tax: result.tax })
                setValue(`measurement[${proposal_id}].products[${index}]`, { total: result.total })
              })
        })
      return copy
    })

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
          .then(res => {})
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

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? parseFloat(copy[maIndex].products[peIndex].total).toFixed(2) : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].price`, value ? value : 0)
      return copy
    })
  }

  const productTotalQty = async (maIndex, peIndex, value) => {
    await setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].products[peIndex].qty = parseFloat(value)
      copy[maIndex].products[peIndex].total = (parseFloat(value) * parseFloat(copy[maIndex].products[peIndex].price)) - parseFloat(copy[maIndex].products[peIndex].discount)

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? parseFloat(copy[maIndex].products[peIndex].total).toFixed(2) : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].qty`, value ? value : 0)
      return copy
    })
  }

  const productTotalDiscount = async (maIndex, peIndex, value) => {
    await setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[maIndex].products[peIndex].discount = parseFloat(value)
      copy[maIndex].products[peIndex].total = (parseFloat(copy[maIndex].products[peIndex].qty) * parseFloat(copy[maIndex].products[peIndex].price)) - parseFloat(value)

      setValue(`measurement[${maIndex}].products[${peIndex}].total`, copy[maIndex].products[peIndex].total ? parseFloat(copy[maIndex].products[peIndex].total).toFixed(2) : 0)
      setValue(`measurement[${maIndex}].products[${peIndex}].discount`, value ? value : 0)
      return copy
    })
  }

  const create_product_estimate = () => {
    const headers = new Headers()
    headers.append("Content-Type", "application/json")
    const data = { productEstimate }
    const init = {
      method: 'POST',
      headers,
      body: JSON.stringify(data)
    }
    return fetch(`/estimates/${estimate.id}/create_products_estimates`, init)
      .then(data => data.json())
  }

  const toggleSelectAllAreas = (maIndex) => {
    productEstimate[maIndex].toggleSelect
    ?
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].toggleSelect = false
      estimate.measurement_areas.map((ma) => {
        copy[maIndex].areas.push(ma.id)
      })
      return copy
    })
    // setProductEstimate(productEstimate => [...productEstimate.slice(0, maIndex), { ...productEstimate[maIndex], areas: [...productEstimate[maIndex].areas, area_id]}])
    :
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]
      copy[maIndex].toggleSelect = true
      copy[maIndex].areas = []
      return copy
    })

    
  }

  const onSubmit = async data => {
    const copy = [...productEstimate]
    const results = copy.map(async (ma, index) => {
      const maCopy = { ...ma }
      maCopy.products = ma.products.map((pe, peIndex) => {
        return { ...pe, ...data.measurement[index].products[peIndex] }
      })
      return maCopy
    })
    
    await Promise.all(results).then(async res => {

      await setProductEstimate(res)

    }).then(() => {})
    console.log('Data', productEstimate)
    create_product_estimate()
      .then(() => window.location = `/estimates/${estimate.id}/view`)
  }

  const handleChange = (index, peIndex, name, value) => {
    setProductEstimate(productEstimate => {
      const copy = [...productEstimate]

      copy[index].products[peIndex].name = value
      setValue(name, value)

      return copy
    })
  }

  return (
    <EstimateContext.Provider
      value={{
        suggestions,
        setSuggestions,
        productEstimate,
        setProductEstimate,
        productAutoComplete,
        setProductAutoComplete,
        maProductListIndex, 
        setMaProductListIndex,
        estimate,
        updateProductList,
        updateSuggestions,
        addSuggestionsToProductList,
        calculateProductLW,
        addArea,
        addProduct,
        setProductEstimate,
        removeProduct,
        selectArea,
        remoteSubmit,
        submitBtnRef,
        refreshArea,
        removeArea,
        productTotalPrice,
        productTotalQty,
        productTotalDiscount,
        create_product_estimate,
        handleSubmit,
        register,
        onSubmit,
        setValue, 
        reset,
        handleChange,
        toggleSelectAllAreas,
        schema,
        errors
      }}
    >
      {children}
    </EstimateContext.Provider>
  )
}