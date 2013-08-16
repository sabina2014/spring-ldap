<#ftl strip_whitespace="true">

<#macro commaSeparatedList strings>
    <#local first=true/>
    <#list strings as listValue>
        <#if !first>
          , <#t/>
        <#else>
          <#local first=false/>
        </#if>
        "${listValue}"<#t/>
    </#list>
</#macro>

<#macro doAttribute attributes>
    <#list attributes as attribute>
       <#local binary=attribute.isBinary?string(", type=Type.BINARY", "")>

       <#lt/>   @Attribute(name="${attribute.javaName}", syntax="${attribute.syntax}"${binary})
       <#if attribute.isMultiValued>
          <#lt/>   private List<${attribute.scalarType}> ${attribute.javaName}=new ArrayList<${attribute.scalarType}>();
       <#else>
             <#lt/>   private ${attribute.scalarType} ${attribute.javaName};
       </#if>
    </#list>
</#macro>
<#macro binaryAttributeList must may>
/**
List of binary attributes to use in context source baseEnvironmentProperties property
If you don't set this property and binary attribute is not one of the well-known binary attributes
the value will be converted to a String and conversion back to byte[] property will fail.
	<entry>
    		<key>
    			<value>java.naming.ldap.attributes.binary</value>
    		</key>
    		<value><#rt/>
        <#list must as attribute>
              <#if attribute.isBinary>
                      <#lt/>${attribute.name} <#rt/>
                   </#if>
            </#list>
        <#list may as attribute>
              <#if attribute.isBinary>
                      <#lt/>${attribute.name} <#rt/>
                   </#if>
            </#list>
        <#lt/></value>
    	</entry>
<#nt>*/
</#macro>

<#macro getSet attributes>
    <#list attributes as attribute>
        <#if attribute.javaName!="objectClass">
            <#if attribute.isMultiValued>
                <#lt/>   public void add${attribute.javaName?cap_first}(${attribute.scalarType} ${attribute.javaName}) {
                <#lt/>      this.${attribute.javaName}.add(${attribute.javaName});
                <#lt/>   }

                <#lt/>   public void remove${attribute.javaName?cap_first}(${attribute.scalarType} ${attribute.javaName}) {
                <#lt/>      this.${attribute.javaName}.remove(${attribute.javaName});
                <#lt/>   }

                <#lt/>   public Iterator<${attribute.scalarType}> get${attribute.javaName?cap_first}Iterator() {
                <#lt/>      return ${attribute.javaName}.iterator();
                <#lt/>   }

            <#else>
                   <#lt/>   public ${attribute.scalarType} get${attribute.javaName?cap_first}() {
                   <#lt/>      return ${attribute.javaName};
                   <#lt/>   }

                <#lt/>   public void set${attribute.javaName?cap_first}(${attribute.scalarType} ${attribute.javaName}) {
                   <#lt/>      this.${attribute.javaName}=${attribute.javaName};
                   <#lt/>   }
            </#if>
        <#else>
            <#lt/>   public Iterator<String> get${attribute.javaName?cap_first}Iterator() {
            <#lt/>      return Collections.unmodifiableList(${attribute.javaName}).iterator();
            <#lt/>   }

        </#if>
    </#list>
</#macro>

<#macro equalsCode attributes>
   <#list attributes as attribute>
      <#lt/>         append(${attribute.javaName}, other.${attribute.javaName}).
   </#list>
</#macro>

<#macro hashCode attributes>
   <#list attributes as attribute>
      <#lt/>         append(${attribute.javaName}).
   </#list>
</#macro>

package ${package};

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.HashSet;
import java.util.ArrayList;
import java.util.Arrays;

import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import javax.naming.Name;
<#list imports as import>
import ${import.packageName}.${import.className};
</#list>

import static org.springframework.ldap.odm.annotations.Attribute.*;
import org.springframework.ldap.odm.annotations.Attribute;
import org.springframework.ldap.odm.annotations.Entry;
import org.springframework.ldap.odm.annotations.Id;

/**
* Generated by Spring LDAP ODM to represent the LDAP object classes:
* <ul>
<#list schema.objectClass as objectClass>
* <li>${objectClass}</li>
</#list>
* </ul>
*/

<@binaryAttributeList schema.must schema.may/>
@Entry(objectClasses={<@commaSeparatedList schema.objectClass/>})
public final class ${class} {

   @Id
   private Name dn;
<@doAttribute schema.must/>
<@doAttribute schema.may/>
   public Name getDn() {
      return dn;
   }

   public void setDn(Name dn) {
      this.dn=dn;
   }

<@getSet schema.must/>
<@getSet schema.may/>
   <#lt/>   @Override
   <#lt/>   public String toString() {
   <#lt/>
   <#lt/>      return new ToStringBuilder(this).
   <#lt/>         append("dn", dn).
   <#list schema.must as attribute>
   <#lt/>         append("${attribute.javaName}", ${attribute.javaName}).
   </#list>
   <#list schema.may as attribute>
   <#lt/>         append("${attribute.javaName}", ${attribute.javaName}).
   </#list>
   <#lt/>         toString();
   <#lt/>   }

   <#lt/>   @Override
   <#lt/>   public int hashCode() {
   <#lt>       return new HashCodeBuilder().
   <@hashCode schema.must/>
   <@hashCode schema.may/>
   <#lt/>      toHashCode();
   <#lt/>    }

   <#lt/>   @Override
   <#lt/>   public boolean equals(Object obj) {
   <#lt/>      if (this == obj)
   <#lt/>         return true;
   <#lt/>      if (obj == null)
   <#lt/>         return false;
   <#lt/>      if (getClass() != obj.getClass())
   <#lt/>         return false;
   <#lt/>
   <#lt/>      ${class} other = (${class}) obj;
   <#lt/>
   <#lt/>      return new EqualsBuilder().
   <#lt/>         append(dn, other.dn).
   <@equalsCode schema.must/>
   <@equalsCode schema.may/>
   <#lt/>         isEquals();
   <#lt/>   }
}


