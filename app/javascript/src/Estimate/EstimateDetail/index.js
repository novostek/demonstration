import React, { useEffect, useState, useContext } from 'react'
import moment from 'moment'
import { useForm } from "react-hook-form";
import axios from 'axios';
import * as yup from "yup";
import { EstimateContext } from '../../context/Estimate';

const schema = yup.object().shape({
  tax_calculation: yup.string().required(),
  ataxpayerge: yup.string().required(),
});

const EstimateDetail = () => {
  const { productEstimate, setProductEstimate, estimate } = useContext(EstimateContext)
  const { register, handleSubmit, setValue } = useForm()

  const onChangeTax = async formData => {
    const data = await axios.put(`/estimates/${estimate.id}/tax_calculation`, { tax_calculation: formData.tax_calculation })
  }

  const onChangeTaxPayer = async formData => {
    const data = await axios.put(`/estimates/${estimate.id}/taxpayer`, { taxpayer: formData.taxpayer })
  }

  const [taxes, setTaxes] = useState([{}])

  useEffect(() => {
    const initialLoad = async () => {
      const {data} = await axios.get('/calculation_formulas/taxes')
      setTaxes(data)
    }

    initialLoad()
  }, [])

  useEffect(() => {
    
    setValue('tax_calculation', estimate.tax_calculation_id)
    setValue('taxpayer', estimate.taxpayer)
    M.AutoInit()
  }, [taxes,])

  return (
    <div className="section">
      <div className="card-panel estimate-details">
        <div className="row">
          <div className="col s5">
            <h6>{estimate.title}</h6>
            <span>{estimate.description}</span>
          </div>
          <div className="col s5">
            <span style={{width: '100%'}} className="left">Customer: {estimate.lead.customer.name}</span>
            <span style={{width: '100%'}} className="left">Location: {estimate.location}</span>
            <span style={{width: '100%'}} className="left">{estimate.category}</span>
          </div>
          <div className="col s2">
            <span className="chip lighten-5 green green-text right mr-0">{estimate.status}</span>
            <span style={{width: '100%'}} className="right right-align">{moment(estimate.created_at).format("MM/DD/YYYY")}</span>
          </div>
        </div>
        <div className="row mt-3">
          <div className="col s12">
            <form name="tax_form">
              <div className="row">
                <div className="input-field col s12 m3 l4">
                  {
                    taxes.length > 0
                    &&
                    <div>
                      <select name="tax_calculation" required ref={register} onChange={handleSubmit(onChangeTax)}>
                        <option value="">Select an option</option>
                        {
                          taxes.map(tax => (
                            <option key={Date.now} value={tax.id}>{tax.name}</option>
                          ))
                        }
                      </select>
                      <label>Taxes</label>
                    </div>
                  }
                </div>

                <div className="input-field col s12 m3 l3">
                  <select name="taxpayer" required onChange={handleSubmit(onChangeTaxPayer)} ref={register}>
                    <option value="">Select an option</option>
                    <option value="customer">Customer will pay</option>
                    <option value="company">We will pay</option>
                  </select>
                  <label>Taxpayer</label>
                    {/* <%= f.select :taxpayer, Estimate.taxpayer.options, {prompt: true}, :selected => @estimate.taxpayer, required: true  %>
                    <%= f.label  :taxpayer %> */}
                </div>  
              </div>    
            </form>
          </div>
        <div>
      </div>
    </div>
    </div>
    </div>
  )
}

export default EstimateDetail
